class Admins::TransitsController < ApplicationController
	layout 'admin'
	before_filter :authenticate_admin!
	
	def index
		@events = current_admin.segreteria? ? Event.all : Event.where(proponent_id: current_admin.id)
		@transits = current_admin.segreteria? ? Transit.all : ( @events.empty? ? [] : Transit.where("event_id IN (#{@events.map(&:id).join(",")})"))
	end
end
