class WebsiteController < ApplicationController  
    #layout 'user'
    layout 'layout_2'
    def index        
        @events = Event.public_available.paginate(:page => params[:page], :per_page => 4)
        @eventsdeleted = Event.deleted.paginate(:page => params[:page], :per_page => 4)
        @eventsclosed = Event.closed.paginate(:page => params[:page], :per_page => 4)
    end

    def documents
    end
    
    def show
        @event = Event.find(params[:id])
        @waiting_lists = WaitingList.where(event_id: @event.id)
    end
    
    def loadmore
      @stop_loading = false
        @events = Event.paginate(:page => params[:page], :per_page => 2)
      if (@events.last and Event.last.id == @events.last.id) or @events.empty?
        @stop_loading = true
      end
    end
end