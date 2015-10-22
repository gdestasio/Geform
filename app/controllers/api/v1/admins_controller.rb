class Api::V1::AdminsController < Api::V1::BaseController
  skip_before_filter :verify_authenticity_token

  def login
    admin = Admin.find_by(email: params[:email])
    
    if admin and admin.valid_password?(params[:password])
      render status: 200, :json => { admin: admin }
      return
    end
      
    render status: 401, json: { message: "errore autenticazione" }
  end
end