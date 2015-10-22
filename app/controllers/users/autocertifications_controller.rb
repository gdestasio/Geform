class Users::AutocertificationsController < ApplicationController
	layout 'user'
	before_filter :authenticate_user!
	
	def index
	end
end