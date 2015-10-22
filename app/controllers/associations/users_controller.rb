class Associations::UsersController < ApplicationController
	layout 'association'
	before_filter :set_user, only: [:show]
	before_filter :authenticate_admin!
	
	def index
		@events = current_admin.segreteria? ? Event.all : Event.where(proponent_id: current_admin.id)
		@users = current_admin.segreteria? ? User.paginate(:page => params[:page]) : ( @events.empty? ? [] : User.where("id IN (SELECT user_id FROM subscriptions WHERE event_id IN (#{@events.map(&:id).join(",")}))")).paginate(:page => params[:page])
	end

	def show
		@transits = @user.transits
	end

private
	def set_user
		@user = User.find(params[:id])
	end
end

