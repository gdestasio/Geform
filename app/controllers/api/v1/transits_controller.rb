class Api::V1::TransitsController < Api::V1::BaseController
	respond_to :json

	def create
		transit = Transit.find_by(id: params[:id])
		
		if transit
			transit.update_attributes(updated_at: Time.now)
			Transit.create(event_id: params[:event_id], user_id: params[:user_id], transited_at: params[:transited_at], operation: params[:operation]== "I" ? 0 : 1, uuid: params[:uuid].blank? ? nil : params[:uuid])
			render :json => {:message => 'transito creato'}, :status => :ok 
			return
		end

		Transit.create(id: params[:id], event_id: params[:event_id], user_id: params[:user_id], transited_at: params[:transited_at], operation: params[:operation]== "I" ? 0 : 1, uuid: params[:uuid].blank? ? nil : params[:uuid])
		render :json => {:message => 'transito creato'}, :status => :ok 
	end

	def index
		transits = params[:updated_at] ? Transit.where("updated_at >= ?", params[:updated_at]) : Transit.all
		render :json => {:transits => transits}, :status => :ok 
	end
end	