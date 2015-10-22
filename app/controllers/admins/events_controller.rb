class Admins::EventsController < ApplicationController
	layout 'admin'

	before_filter :authenticate_admin!, except: [:download_brochure]
	before_filter :set_event, only: [:show, :edit, :destroy, :update, :change_status, :booked, :waiting]

	def index
		h = Hash.new
		@events_available = []
		@pagination = true

		Event.all.each do |e|
		h['label'] = "<strong>#{e.name}</strong> - #{e.date}"
		h['value'] = e.id
		@events_available.push(h)
		h = Hash.new
	    end

	    if params[:query]
			query = params[:query]
			@events = Event.find_by_sql("SELECT * FROM events WHERE name LIKE '%#{query.downcase}%' OR location LIKE '%#{query.downcase}%' OR start_at LIKE '%#{query.downcase}%'")
			@pagination = false
			return
		end
		@events = current_admin.segreteria? ? Event.all : Event.where(proponent_id: current_admin.id)
		if params[:closing]		
			@events = @events.where('status=1 and end_at < ?', Time.now)		
		end
		# enum status: { "creato" => 0, "schedulato" => 1, "cancellato" => 2, "proposto" => 3, "chiuso" => 4, "scaduto" => 5 }
		if params[:status]
			@events = @events.where('status=?', params[:status])		
		end
		@events = @events.paginate(:page => params[:page])
	end

	def edit
		h = Hash.new
		@birthplaces = []		
		City.all.each do |city|
			h['label'] = city.name
			h['value'] = city.belfiore
			@birthplaces.push(h)
			h = Hash.new
		end
	end

	def new		
		@event = Event.new		
		@event.min_presence_percentage = 100
		h = Hash.new
		@birthplaces = []

		City.all.each do |city|
			h['label'] = city.name
			h['value'] = city.belfiore
			@birthplaces.push(h)
			h = Hash.new
		end
	end

	def new_out_of_credits
		session[:credits] = 0
		session[:generator] = ""
		redirect_to admins_events_new_path
	end

	def booked
		@users = User.where(id: @event.subscriptions.map(&:user_id)).paginate(:page => params[:page])
	end

	def waiting
		@users = User.where(id: @event.waiting_lists.map(&:user_id)).paginate(:page => params[:page])
	end

	def show
		@waiting_lists = WaitingList.where(event_id: @event.id)
	end

	def loadmore
	  @stop_loading = false
		@events = Event.paginate(:page => params[:page])
	  if (@events.last and Event.last.id == @events.last.id) or @events.empty?
	    @stop_loading = true
	  end
  	end

  	def remove_brochure
  		@event = Event.find(params[:event_id])  	
  		if not @event.brochure.blank? and File.exists?("#{Rails.root}/private/system/events/#{params[:event_id]}/"+@event.brochure.to_s)
			File.delete("#{Rails.root}/private/system/events/#{params[:event_id]}/"+@event.brochure.to_s)		
		end	  		
  		@event.brochure = nil
  		@event.save
  		render status: 200 , json: { }
  	end

  	def download_brochure
  		@event = Event.find(params[:event_id])  	
  		if not @event.brochure.blank? and File.exists?("#{Rails.root}/private/system/events/#{params[:event_id]}/"+@event.brochure.to_s)
  			send_file "#{Rails.root}/private/system/events/#{params[:event_id]}/"+@event.brochure.to_s, :filename => @event.brochure.to_s, :x_sendfile => true
  		end
  	end

	def create
		@event = Event.new(event_params)
		#@event.proponent_id = current_admin.id
		@event.status = 'creato'

		if @event.save
			if not params[:brochure].nil?
				save_brochure(params[:brochure],@event.id,params[:brochure].original_filename)
				@event.brochure = params[:brochure].original_filename								
				@event.save
			end			
			EventUserTitle.where(event_id: @event.id).destroy_all
			if params[:user_title]
				puts params[:user_title]
				params[:user_title].to_a.each do |user_title|
				eut = EventUserTitle.new
				eut.event_id = @event.id
				eut.user_title = user_title
				eut.save
			  end
			end		

			Speaker.where(event_id: @event.id).destroy_all
			params[:event][:speakers].split(",,;").each do |speaker|
				Speaker.create(event_id: @event.id, name: speaker)
			end
			
			flash[:success] = "Evento creato"
			redirect_to admins_events_show_path(id: @event.id)
		else
			flash[:error] = "Errore creazione evento #{@event.errors.messages}"
			render :new
		end
	end

	def update
		if not @event.brochure.blank? and File.exists?("#{Rails.root}/private/system/events/#{params[:id]}/"+@event.brochure.to_s)
			File.delete("#{Rails.root}/private/system/events/#{params[:id]}/"+@event.brochure.to_s)		
		end		
		if @event.update_attributes(event_params)					
			if not params[:brochure].nil?
				save_brochure(params[:brochure],@event.id,params[:brochure].original_filename)
				@event.brochure = params[:brochure].original_filename								
				@event.save		
			end
			EventUserTitle.where(event_id: @event.id).destroy_all			
			if params[:user_title]
				puts params[:user_title]
				params[:user_title].to_a.each do |user_title|
					eut = EventUserTitle.new
					eut.event_id = @event.id
					eut.user_title = user_title
					eut.save
				end
			end		
			Speaker.where(event_id: @event.id).destroy_all
			params[:event][:speakers].split(",,;").each do |speaker|
				Speaker.create(event_id: @event.id, name: speaker)
			end

			if @event.status == "schedulato"
				EventUpdatedWorker.perform_async(@event.id)
			end
			
			flash[:success] = "Evento modificato"
			redirect_to admins_events_show_path(id: @event.id)
		else
			flash[:error] = "Errore nella modifica dell'evento #{@event.errors.messages}"
			render :edit
		end
	end

	def destroy
		EventUserTitle.where(event_id: @event.id).destroy_all
		Speaker.where(event_id: @event.id).destroy_all
		@event.destroy			
		flash[:success] = "Evento rimosso correttamente"
		redirect_to admins_events_path
	end

	def change_status
		@event.update_attributes(status: params[:status])
		flash[:success] = "Stato dell'evento modificato in #{@event.status}"

		if @event.status == "schedulato" and @event.proponent_id
			AccountMailer.to_association_event_scheduled(@event).deliver_now			
		end
		if @event.status == "schedulato" 
			EventCreatedWorker.perform_async(@event.id)
		end
		if @event.status == "cancellato"
			EventDeletedWorker.perform_async(@event.id)
		end

		redirect_to admins_events_show_path(id: @event.id)
	end

	def transits
	end

	def generator
	end

	def generate
		session[:generator] = params[:generator]
		
		credits = 0
		if params[:generator][:options]
			params[:generator][:options].each do |option|
				criteria = Criterium.find(option[0])
				credits += criteria ? criteria.importance : 0
				credits += Option.where(criteria_id: option[0], name: option[1]).first.importance
			end
		end
 		
		credits = params[:generator][:duration] == "Giornata Intera" ? credits + 1 : credits
		credits = credits > 3.5 ? 4 : credits
		
 		session[:credits] = credits
 		redirect_to admins_events_credits_path
	end
	
	def credits
	end

	def close_event
		event = Event.find(params[:id])
	  	event.status=4
	  	event.updated_at = Time.now
	  	event.save  	
	  	generate_credits
	  	# render status: 200 , json: { event:  event }
	  end
  	

	def generate_credits
		event = Event.find(params[:id])
		event_time = (event.end_at - event.start_at).to_i
	  	min_presence_time = event_time * event.min_presence_percentage / 100  	
	  	#Calcolare i crediti per gli utenti
	  	transits = Transit.where(event_id: event.id)
	  	subscriptions = Subscription.where(event_id: event.id)
	  	subscriptions.each do |subscription|
	  		user_id = subscription.user_id
	  		transit_per_user = transits.where(user_id: user_id).order(transited_at: :asc)
	  		last_transit = nil
	  		time = 0  		
	  		transit_per_user.each do |tr|  			
	  			#fetch first entrance
	  			if last_transit==nil
	  				if tr.operation=='U' 
	  					next
	  				end
	  			end  			
	  			if last_transit!=nil 
	  				if last_transit.operation=='I' and tr.operation=='U'  		
	  					entrance_time = last_transit.transited_at
	  					exit_time = tr.transited_at 			
	  					if entrance_time < event.start_at
	  						entrance_time = event.start_at
	  					end
	  					if exit_time > event.end_at
	  						exit_time = event.end_at
	  					end
	  					time += (exit_time - entrance_time).to_i
	  				end
	  			end
	  			last_transit = tr  		
	  		end
	  		if time>min_presence_time
	  			subscription.credits = event.credits  			
	  		else
	  			subscription.credits = 0 
	  		end
	  		subscription.save
  		end
  		render status: 200 , json: { event:  event }
	end


	private

	def save_brochure(file,event_id,filename)
		Dir.mkdir("#{Rails.root}/private") unless File.exists?("#{Rails.root}/private")
		Dir.mkdir("#{Rails.root}/private/system") unless File.exists?("#{Rails.root}/private/system")
		Dir.mkdir("#{Rails.root}/private/system/events") unless File.exists?("#{Rails.root}/private/system/events")
		Dir.mkdir("#{Rails.root}/private/system/events/#{event_id}") unless File.exists?("#{Rails.root}/private/system/events/#{event_id}")
		FileUtils.cp file.tempfile.path, "#{Rails.root}/private/system/events/#{event_id}/"+filename.to_s
	end

	def set_event
		@event = Event.find(params[:id])
	end

  def event_params
    params.require(:event).permit(:name, :description, :start_at, :end_at, :city, :address, :credits, :min_presence_percentage, :seats, :location, :closing_at, :category, :brochure)
  end
end
