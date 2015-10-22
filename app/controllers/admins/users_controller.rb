class Admins::UsersController < ApplicationController
	layout 'admin'
	before_filter :set_user, only: [:show, :edit, :destroy, :update]
	before_filter :set_autocomplete, only: [:new, :edit]
	before_filter :authenticate_admin!
	
	def index
		h = Hash.new
		@users_available = []
		@pagination = true

		User.all.each do |u|
      h['label'] = "<strong>#{u.name}</strong> - #{u.taxcode}"
      h['value'] = u.id
      @users_available.push(h)
      h = Hash.new
    end

    if params[:query]
			query = params[:query]
			@users = User.find_by_sql("SELECT * FROM users WHERE first_name LIKE '%#{query.downcase}%' OR last_name LIKE '%#{query.downcase}%' OR email LIKE '%#{query.downcase}%' OR taxcode LIKE '%#{query.downcase}%'")
			@pagination = false
			return
		end

		@events = current_admin.segreteria? ? Event.all : Event.where(proponent_id: current_admin.id)
		@users = current_admin.segreteria? ? User.paginate(:page => params[:page]) : ( @events.empty? ? [] : User.where("id IN (SELECT user_id FROM subscriptions WHERE event_id IN (#{@events.map(&:id).join(",")}))")).paginate(:page => params[:page])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params.except(:delivery_1_city_id))
		city = City.where(name: params[:user][:delivery_1_city_id]).first
		
		@user.delivery_1_city_id = city.id
		@user.password = SecureRandom.hex(8).upcase
		@user.confirmed_at = Time.now
		if @user.save
			AccountMailer.to_user_invite(@user,@user.password).deliver_now
			flash[:success] = "Utente creato"
			redirect_to admins_users_path
		else
			flash[:error] = "Errore creazione utente #{@user.errors.messages}"
			render :new
		end
	end

	def update
		if @user.update_attributes(user_params.except(:delivery_1_city_id))
			city = City.where(name: params[:user][:delivery_1_city_id]).first
			@user.delivery_1_city_id = city.id
			@user.save
			flash[:success] = "Utente modificato"
			redirect_to admins_users_show_path(id: @user.id)
		else
			flash[:error] = "Errore modifica utente #{@user.errors.messages}"
			render :new
		end
	end

	def loadmore
	  @stop_loading = false
		@users = User.paginate(:page => params[:page])
	  if (@users.last and User.last.id == @users.last.id) or @users.empty?
	    @stop_loading = true
	  end
  end

	def show
		#category: { "ordinamento" => 0, "previdenza / assistenza" => 1, "deontologia" => 2, "altro" => 3 }
		#TO-DO 
		#Sum extra credits
		@training_plan = TrainingPlan.where('NOW() between start_at AND end_at').first		
		events = Event.where('start_at between ? and ?',@training_plan.start_at,@training_plan.end_at)				
		@transits = @user.transits.where('event_id IN (?)',events.map(&:id))
		@subscriptions = @user.subscriptions.where('event_id in (?)',events.map(&:id))
		@tot_credits = @subscriptions.sum(:credits)
		@tot_credits_cat_0 = @subscriptions.where('event_id IN (?)',events.where('category = 0').map(&:id)).sum(:credits)
		@tot_credits_cat_1 = @subscriptions.where('event_id IN (?)',events.where('category = 1').map(&:id)).sum(:credits)
		@tot_credits_cat_2 = @subscriptions.where('event_id IN (?)',events.where('category = 2').map(&:id)).sum(:credits)
		@tot_credits_cat_3 = @subscriptions.where('event_id IN (?)',events.where('category = 3').map(&:id)).sum(:credits)		
	end

private
	def set_user
		@user = User.find(params[:id])
	end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :pec, :delivery_1_address, :delivery_1_city_id, :delivery_1_country_id, :delivery_1_zip, :delivery_1_phone, :taxcode, :title,:birthdate,:card_number,:albo_subscription_at)
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

