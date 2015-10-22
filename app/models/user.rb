class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  enum category: { "Praticante Semplice" => 0, "Praticante Abilitato" => 1, "Avvocato" => 2 }
  enum title: { "Avv." => 0, "Abogado" => 1,"Avocado" => 2, "Avv. Prof." => 3, "Dikigoros" => 4, "Praticante" => 5 }
  
  enum status: { "pending" => 0, "active" => 1, "cancelled" => 2, "suspended" => 3}

  before_save :ensure_authentication_token

  has_many :subscriptions
  has_many :events, through: :subscriptions
  has_many :waiting_lists
  has_many :events, through: :waiting_lists
  has_many :transits
  has_many :certificates

  default_scope { order('created_at DESC') }

  belongs_to :city  
  belongs_to :country
  belongs_to :province
  belongs_to :state

  def name
    @name ||= "#{title} #{first_name.capitalize} #{last_name.capitalize}"
  end

  def extended_address
    @extended_address ||= "#{address ? address + "," : ''} #{!city.nil? ? city.name : '' }#{!province.nil? ? "(" + province.name + ")," : ''} #{zip}"
  end

  def extended_delivery_1_address
    @extended_delivery_1_address ||= "#{delivery_1_address ? delivery_1_address + "," : ''} #{!delivery_1_city_id.nil? ? City.find(delivery_1_city_id).name : '' }#{!delivery_1_province.nil? ? "(" + Province.find(delivery_1_province).name + ")," : ''} #{delivery_1_zip}"
  end

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def status_des
    if self.status=="pending" 
      "Pre-attivato"
    elsif self.status=="active"
      "Attivo"
    elsif self.status=="cancelled"
      "Eliminato"
    elsif self.status=="suspended"
      "Sospeso"
    end
  end

  def status_color
    if self.status=="pending" 
      "#E5BB00"
    elsif self.status=="active"
      "#03B700"
    elsif self.status=="cancelled"
      "#ff0000"
    elsif self.status=="suspended"
      "#A0A0A0"
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end


end
