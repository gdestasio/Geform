class AdminsController < ApplicationController
	before_filter :authenticate_admin!
	layout 'admin'

	def index
		@events = current_admin.segreteria? ? Event.all : Event.where(proponent_id: current_admin.id)
		@users = current_admin.segreteria? ? User.all : ( @events.empty? ? [] : User.where("id IN (SELECT user_id FROM subscriptions WHERE event_id IN (#{@events.map(&:id).join(",")}))"))
		@transits = current_admin.segreteria? ? Transit.all : ( @events.empty? ? [] : Transit.where("event_id IN (#{@events.map(&:id).join(",")})"))
		@associations = Admin.where(role: 1) 
	end
end