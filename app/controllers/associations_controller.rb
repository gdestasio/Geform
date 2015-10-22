class AssociationsController < ApplicationController
	before_filter :authenticate_admin!
	layout 'association'

	def index
		@events = Event.where(proponent_id: current_admin.id)
		@users = User.where("id IN (SELECT user_id FROM subscriptions WHERE event_id IN (#{@events.map(&:id).join(",")}))")
		@transits = @events.empty? ? [] : Transit.where("event_id IN (#{@events.map(&:id).join(",")})")
	end
end