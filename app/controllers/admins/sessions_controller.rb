class Admins::SessionsController < Devise::SessionsController
  layout 'admin'

  def new
    super
  end

  def create
    admin = Admin.where(email: (params[:admin][:email]).downcase).first

    if admin and admin.valid_password?(params[:admin][:password])
      resource = warden.authenticate!(:scope => resource_name, :recall => 'new')
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, resource)
    else
      flash[:error] = "Email e/o password non valide"
      redirect_to new_admin_session_path and return
    end
  end

  def destroy
    super
  end

  def resource_name
    :admin
  end

  def resource
    @resource ||= Admin.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:admin]
  end
end
