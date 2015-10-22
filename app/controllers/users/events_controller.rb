class Users::EventsController < ApplicationController
	layout 'user'
	before_filter :set_event, only: [:show, :edit, :destroy, :update, :join, :revoke, :add_wl, :remove_wl, :ical]
	before_filter :authenticate_user!
	
	def index

		if params[:status]
			if params[:status] == "subscribed"
				@events = Event.where(id: current_user.subscriptions.map(&:event_id)).paginate(:page => params[:page])
				return
			end

			if params[:status] == "waiting"
				@events = Event.where(id: current_user.waiting_lists.map(&:event_id)).paginate(:page => params[:page])
				return
			end
		end

		@events = Event.available.paginate(:page => params[:page])
	end

	def show
		@waiting_lists = WaitingList.where(user_id: current_user.id, event_id: @event.id)
		@subscriptions = Subscription.where(user_id: current_user.id, event_id: @event.id)
	end

	def loadmore
	  @stop_loading = false
		@events = Event.available.paginate(:page => params[:page])
	  if (@events.last and Event.available.last.id == @events.last.id) or @events.empty?
	    @stop_loading = true
	  end
  end

	def ical
	  respond_to do |wants|
	    wants.html
	    wants.ics do
	      calendar = Icalendar::Calendar.new
	      calendar.add_event(@event.to_ics)
	      calendar.publish
	      render :text => calendar.to_ical
	    end
	  end
	end

	def join
		Subscription.create(event_id: @event.id, user_id: current_user.id)
		AccountMailer.to_user_subscription_confirmed(@event, current_user).deliver_now
		flash[:success] = "Iscrizione all'evento #{@event.name} confermata"
		redirect_to users_events_show_path(@event)
	end

	def revoke
		Subscription.where(event_id: @event.id, user_id: current_user.id).destroy_all
		waiting_lists = WaitingList.where(event_id: @event.id)

		if not waiting_lists.empty?
			wl = waiting_lists.first
			Subscription.create(event_id: @event.id, user_id: wl.user_id)
			wl.destroy
			AccountMailer.to_user_seat_available(@event, wl.user).deliver_later
		end

		AccountMailer.to_user_event_subscription_revoked(current_user, @event).deliver_later
		flash[:success] = "Partecipazione all'evento #{@event.name} revocata"
		redirect_to users_events_show_path(@event)
	end

	def add_wl
		WaitingList.create(event_id: @event.id, user_id: current_user.id)
		flash[:success] = "Aggiunto alla lista di attesa dell'evento #{@event.name}"
		redirect_to users_events_show_path(@event)
	end

	def remove_wl
		WaitingList.where(event_id: @event.id, user_id: current_user.id).destroy_all
		flash[:success] = "Rimosso dalla lista di attesa dell'evento #{@event.name}"
		redirect_to users_events_show_path(@event)
	end
	
private
	def set_event
		@event = Event.find(params[:id])
	end

  def event_params
    params.require(:event).permit(:name, :description, :start_at, :end_at, :location, :credits, :min_presence_percentage, :seats)
  end
end
