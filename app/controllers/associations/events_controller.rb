class Associations::EventsController < ApplicationController
	layout 'association'
	before_filter :set_event, only: [:show, :edit, :destroy, :update, :booked, :waiting]
	before_filter :authenticate_admin!

	def index
		@events = Event.where(proponent_id: current_admin.id)
	end

	def new
		@event = Event.new
	end

	def show
		@users = User.where(id: @event.subscriptions.map(&:user_id)).paginate(:page => params[:page])
	end

	def create
		@event = Event.new(event_params)
		@event.proponent_id = current_admin.id
		@event.status = "proposto"
		
		if @event.save
			AccountMailer.to_admin_new_event(current_admin, @event).deliver_later
			flash[:success] = "Evento proposto, in attesa di valutazione da parte della segreteria"
			redirect_to associations_events_path
		else
			flash[:error] = "Errore creazione evento #{@event.errors.messages}"
			render :new
		end
	end

	def update
		if @event.update_attributes(event_params)
			flash[:success] = "Evento modificato"
			redirect_to associations_events_show_path(id: @event.id)
		else
			flash[:error] = "Errore nella modifica dell'evento #{@event.errors.messages}"
			render :edit
		end
	end

	def booked
		@users = User.where(id: @event.subscriptions.map(&:user_id)).paginate(:page => params[:page])
	end

	def waiting
		@users = User.where(id: @event.waiting_lists.map(&:user_id)).paginate(:page => params[:page])
	end
	
	private
	
	def set_event
		@event = Event.find(params[:id])
	end

  def event_params
    params.require(:event).permit(:name, :description, :start_at, :end_at, :city, :address, :credits, :min_presence_percentage, :seats, :location, :closing_at, :category)
  end
end
