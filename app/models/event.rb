# models/event.rb
class Event < ActiveRecord::Base
  include ApplicationHelper

  before_create :assign_token
  belongs_to :proponent, class_name: 'Admin'
  belongs_to :validator, class_name: 'Admin'

  has_many :subscriptions
  has_many :waiting_lists
  has_many :event_user_titles
  default_scope { order('created_at DESC') }

  scope :available, -> { where status: [1,2,4,5] }
  scope :public_available, -> { where status: [1] }
  scope :deleted, -> { where status: [2] }
  scope :closed, -> { where status: [4] }
  
  has_many :users, through: :subscriptions
  has_many :speakers

  enum status: { "creato" => 0, "schedulato" => 1, "cancellato" => 2, "proposto" => 3, "chiuso" => 4, "scaduto" => 5 }
  enum category: { "ordinamento" => 0, "previdenza / assistenza" => 1, "deontologia" => 2, "altro" => 3 }

  def day
    @day = start_at.day
  end

  def month
    @month = month_to_ita(start_at.month.to_s)
  end

  
  def date
    #April 25, 2015 00:00 - 00:00
    month = month_to_ita(start_at.month.to_s)
    @date ||= "#{start_at.day} #{month}, #{start_at.year} dalle #{start_at.strftime("%H:%M")} alle #{end_at.strftime("%H:%M")}"
  end

  def longaddress
    zip = ZipT.where(city: city).first
    @longaddress ||= "#{address} - #{city}"
  end

  def to_ics
    event = Icalendar::Event.new
    event.start = self.start_at.strftime("%Y%m%dT%H%M%S")
    event.end = self.end_at.strftime("%Y%m%dT%H%M%S")
    event.summary = self.name
    event.description = self.description
    event.location = self.location
    event.klass = "PUBLIC"
    event.created = self.created_at
    event.last_modified = self.updated_at
    event.uid = event.url = "#{PUBLIC_URL}events/#{self.id}"
    event
  end

  protected

  def month_to_ita(month)
    ita = case month
      when "1" then "Gennaio"
      when "2" then "Febbraio"
      when "3" then "Marzo"
      when "4" then "Aprile"
      when "5" then "Maggio"
      when "6" then "Giugno"
      when "7" then "Luglio"
      when "8" then "Agosto"
      when "9" then "Settembre"
      when "10" then "Ottobre"
      when "11" then "Novembre"
      when "12" then "Dicembre"
    end
    return ita
  end

  def assign_token
    self.token = loop do
      token = SecureRandom.urlsafe_base64(32)
      break token unless Event.find_by(token: token)
    end
  end
end
