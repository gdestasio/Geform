class Api::V1::EventsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  def index
    events = params[:updated_at] ? Event.where("updated_at >= ? and status<>4", params[:updated_at]) : Event.all.where('status<>4')
    render status: 200, json: { events:  events }
  end

  def show
    event = Event.find(params[:id])
    render status: 200 , json: { event:  event }
  end

end