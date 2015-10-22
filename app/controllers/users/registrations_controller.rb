class Users::RegistrationsController < Devise::RegistrationsController
	layout 'user'
	
	def new
		super
	end

	def create
		@user_email = User.find_by(email: params[:user][:email])
		@user_taxcode = User.find_by(taxcode: params[:user][:taxcode])

		if @user_email or @user_taxcode
			flash[:alert] = "Attenzione! Utente già registrato."
			clean_up_passwords(@user)
	    redirect_to :back and return
		end

		@user = User.new(user_params)
		if @user.save
			UserConfirmationWorker.perform_async(@user.id)
			sign_in(@user)
	   	redirect_to users_path
		else
			clean_up_passwords(@user)
	    render :new
		end
	end
	
	private
  
  def user_params
    params.require(:user).permit(:first_name,:last_name, :email, :password, :taxcode)
  end
end
