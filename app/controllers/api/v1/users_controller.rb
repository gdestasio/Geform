class Api::V1::UsersController < Api::V1::BaseController
	respond_to :json

	def index
		users = params[:updated_at] ? User.where("updated_at >= ?", params[:updated_at]) : User.all
		render :json => {users: users}, :status => :ok 
	end

	def create
		user = params[:user]
		password = SecureRandom.hex(8).upcase
		u = User.new(first_name: user[:first_name], last_name: user[:last_name], taxcode: user[:taxcode], email: user[:email], card_number: user[:card_number].blank? ? nil : user[:card_number], password: password)
		if u.save
			render :json => {user: user}, :status => :ok 
			return
		end

		render status: 500, json: { message: "#{u.errors.messages}"}
	end
end	