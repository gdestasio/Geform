class Api::V1::BaseController < ApplicationController
	before_filter :authentication, except: :login
	skip_before_filter :verify_authenticity_token
	before_filter :set_headers 
	# protect_from_forgery with: :null_session
	
	respond_to :json

	def options
	  set_headers
	  # this will send an empty request to the client with 200 status code (OK, can proceed)
	  render :text => '', :content_type => 'text/plain'
	end

protected
	def authentication
		@admin = Admin.find_by(authentication_token: params[:authentication_token])
		if not @admin
			render status: 401, json: { message: "errore autenticazione" }
			return false
		end
		return true
	end

	def ensure_auth
		@admin = Admin.where(authentication_token: params[:authentication_token])
		@admint = @admin || params[:authentication_token]
	end

	# Set CORS
  def set_headers
    headers["Access-Control-Allow-Origin"] = '*'
    headers['Access-Control-Expose-Headers'] = 'Etag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*, x-requested-with, Content-Type, If-Modified-Since, If-None-Match, Authorization'
    headers['Access-Control-Max-Age'] = '86400'
  end
end