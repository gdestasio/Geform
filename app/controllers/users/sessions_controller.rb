class Users::SessionsController < Devise::SessionsController
  layout 'user'
  @type=''
  def new
    super
  end

  def create
    user = User.where(email: (params[:user][:email]).downcase).first

    if user and user.valid_password?(params[:user][:password])
      @type='user'
      #resource = warden.authenticate!(:scope => resource_name, :recall => 'new')      
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, user)
      return
    end
    admin = Admin.where(email: (params[:user][:email]).downcase).first

    if admin and admin.valid_password?(params[:user][:password])
      @type='admin'
      #resource = warden.authenticate!(:scope => resource_name, :recall => 'new')      
      set_flash_message :notice, :signed_in
      sign_in_and_redirect(resource_name, admin)
      return              
    end
    flash[:error] = "Email e/o password non valide"
    redirect_to new_user_session_path and return

  end

  def destroy
    super
  end

  def resource_name
    if @type=='admin'
      :admin
    else
      :user      
    end
  end

  def resource
    if @type=='admin'
      @resource ||= Admin.new
    else
      @resource ||= User.new      
    end
  end

  def devise_mapping
    if @type=='admin'
      @devise_mapping ||= Devise.mappings[:admin]
    else
      @devise_mapping ||= Devise.mappings[:user]      
    end    
  end
end
