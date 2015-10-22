class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :update_sanitized_params, if: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  def after_sign_in_path_for(resource)    
    if (resource.class == User)      
      stored_location_for(:user) || users_path
    elsif (resource.class == Admin)
      if resource.segreteria?
        stored_location_for(:admin) || admins_path
      else
        stored_location_for(:admin) || associations_path
      end
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    if (resource == :admin)
      new_admin_session_path
    else
      root_path      
    end
  end

  def after_sign_up_path_for(resource)
    if (resource.class == User)
      stored_location_for(:user) || users_path
    elsif (resource.class == Admin)
      stored_location_for(:admin) || admins_path
    else
      root_path
    end
  end

  def layout_by_resource
    if devise_controller?
      "user"
    else
      "application"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation)}
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation)}
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
