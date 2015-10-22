class Api::V1::SubscriptionsController < Api::V1::BaseController
	respond_to :json

	def index
		subscriptions = params[:updated_at] ? Subscription.where("updated_at >= ?", params[:updated_at]) : Subscription.all
		render :json => { subscriptions: subscriptions }, status: :ok 
	end

	def create
		subscriptions = Subscription.where(event_id: params[:event_id], user_id: params[:user_id])

		if not subscriptions.empty?
		  render :json => { subscriptions: subscriptions }, status: :ok 
			return
		end

		subscription = Subscription.new(event_id: params[:event_id], user_id: params[:user_id])
		subscription.save
		render :json => { subscription: subscription }, status: :ok 
	end
end	