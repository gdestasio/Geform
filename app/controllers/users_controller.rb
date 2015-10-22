class UsersController < ApplicationController
	before_filter :authenticate_user!, except: [:confirmation]
	before_filter :set_autocomplete, only: [:index]
	layout 'user'

	def index
		@user = current_user
		@events = Event.available.limit(6)
	end

	def confirmation
		@user = User.find_by(authentication_token: params[:token])
		@user.update_attributes(confirmed_at: Time.now)
		sign_in(@user)
	  redirect_to users_path
	end

	def edit
		@user = current_user
	end

	def activate
		@user = current_user
		if @user.update_attributes(user_params.except(:city_id))
			city = City.where(name: params[:user][:city_id]).first
			@user.city_id = city.id
			@user.status = "active"
			@user.save
		
			UserActivationWorker.perform_async(@user.id)
			flash[:success] = "Utente attivato"
			redirect_to users_path
		else
			flash[:error] = "Errore attivazione utente #{@user.errors.messages}"
			render users_path
		end
	end

	private

	def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :pec, :address, :city_id, :country_id, :zip, :cell, :taxcode)
  end

	def set_autocomplete
		h = Hash.new
		@cities = []

		City.all.each do |city|
			h['label'] = city.name
			h['value'] = city.id
			@cities.push(h)
			h = Hash.new
		end
  end
end