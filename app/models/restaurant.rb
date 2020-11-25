# frozen_string_literal: true

class Restaurant < ApplicationRecord
  belongs_to :cuisine

  belongs_to :restaurant_user
  has_one :opening_time
  has_many :delivery_postcodes
  has_many :receipts
  has_many :menus
  belongs_to :currency
  has_many :restaurant_tables
  has_many :custom_lists, -> { order(position: :asc) }
  has_and_belongs_to_many :features
  has_and_belongs_to_many :template

  # has_many :tables, through: :restaurant_tables

  validates_presence_of :name, on: %i[create update], message: "can't be blank"
  validates_presence_of :address, on: %i[create update], message: "can't be blank"
  validates_presence_of :postcode, on: %i[create update], message: "can't be blank"
  validates_presence_of :telephone, on: %i[create update], message: "can't be blank"
  validates_presence_of :email, on: %i[create update], message: "can't be blank"
  validates_uniqueness_of :path, on: %i[create update], message: "must be unique"
  validates_uniqueness_of :restaurant_user_id, on: %i[create update], message: "must be unique"

  delegate :name, to: :cuisine, prefix: true
  delegate :ids, to: :features, prefix: true
  delegate :live_menus, to: :menus, prefix: true
  delegate :times, :delay_time_minutes, :kitchen_delay_minutes, to: :opening_time, prefix: true
  delegate :name, :code, :symbol, to: :currency, prefix: true

  before_create :set_slug

  has_one_attached :image
  has_one_attached :background_image

  def background
    if subtle_background.present? and subtle_background != 'None'
      back = "/background/#{subtle_background}.png"
    end
 end


  def stripe_sk_api_key
    Rails.env == 'production' ? stripe_api_key : 'sk_test_hOj5WqYB26UV1v5uuqXsADSG'
  end
  
  def stripe_pk_api_key
    Rails.env == 'production' ? stripe_publish_api_key : 'pk_test_WK72bUcdjoVsncoNFQGrFkcv'
  end
  
    
  def set_slug
    if slug.blank? 
      token_chars = ('A'..'Z').to_a.delete_if { |i| i == 'O' } + ('1'..'9').to_a
      token_length = 6
      self.slug = Array.new(token_length) { token_chars[rand(token_chars.length)] }.join
    end
  end

  def is_open
    t = Time.new.in_time_zone('Europe/London')
    today_day = t.strftime("%A").downcase
    today_opening_time = opening_time_times[today_day]['open']
    today_closing_time = opening_time_times[today_day]['close']
    time_today_opening = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_opening_time}:00 +01:00")
    time_today_closing = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_closing_time}:00 +01:00") - opening_time_kitchen_delay_minutes.minutes
    time_today_opening < t and t < time_today_closing
  end
  def is_closing(notice = 0)
    t = Time.new.in_time_zone('Europe/London')
    today_day = t.strftime("%A").downcase
    today_opening_time = opening_time_times[today_day]['open']
    today_closing_time = opening_time_times[today_day]['close']
    time_today_opening = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_opening_time}:00 +01:00")
    time_today_closing = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_closing_time}:00 +01:00") - opening_time_kitchen_delay_minutes.minutes

    ((time_today_closing - t)/60).to_i

    
  end
    


  def available_times
    # Delay time minutes
    dtm = opening_time_delay_time_minutes.minutes
    dtm = 30.minutes if dtm.blank?

    # Busy time minutes
    btm = opening_time_kitchen_delay_minutes.minutes

    t = Time.new.in_time_zone('Europe/London')
    tomorrow = Time.new.in_time_zone('Europe/London') + 1.day
    #  binding.pry
    # rounded_t = Time.local(t.year, t.month, t.day, t.hour, t.min/15*15)
    round_down_t = Time.parse("#{t.year}-#{t.month}-#{t.day} #{t.hour}:#{t.min/15*15}:00")
    rounded_t = round_down_t + 15.minutes
    
    delivery_time_options = [{value: "ASAP", text: "ASAP"}]
    
    
    today_day = t.strftime("%A").downcase
    tomorrow_day = (tomorrow).strftime("%A").downcase
    today_opening_time = opening_time_times[today_day]['open']
    today_closing_time = opening_time_times[today_day]['close']
    # time_today_opening = Time.local(t.year, t.month, t.day, today_opening_time.split(':').first, today_opening_time.split(':').last)
    # time_today_opening = Time.local(t.year, t.month, t.day, today_opening_time.split(':').first, today_opening_time.split(':').last)
    
    time_today_opening = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_opening_time}:00")
    time_today_closing = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_closing_time}:00")
    
    
    
    tomorrow_opening_time = opening_time_times[tomorrow_day]['open']
    tomorrow_closing_time = opening_time_times[tomorrow_day]['close']
    # time_tomorrow_opening = Time.local(tomorrow.year, tomorrow.month, tomorrow.day, tomorrow_opening_time.split(':').first, tomorrow_opening_time.split(':').last)
    # time_tomorrow_closing = Time.local(tomorrow.year, tomorrow.month, tomorrow.day, tomorrow_closing_time.split(':').first, tomorrow_closing_time.split(':').last)
    
    time_tomorrow_opening = Time.parse("#{tomorrow.year}-#{tomorrow.month}-#{tomorrow.day} #{tomorrow_opening_time}:00")
    time_tomorrow_closing = Time.parse("#{tomorrow.year}-#{tomorrow.month}-#{tomorrow.day} #{tomorrow_closing_time}:00")
    
    # Set first available time today
    if rounded_t > time_today_opening
      next_time_today = rounded_t + dtm + btm
    else
      next_time_today = time_today_opening + dtm
    end
    # and tomorrow
    first_time_tomorrow = time_tomorrow_opening + dtm

    until rounded_t > time_today_closing - btm
      if rounded_t >= next_time_today
          delivery_time_options << {value: rounded_t.strftime("%H:%M"), text: "Today: #{rounded_t.strftime("%H:%M")}"} 
      end
      rounded_t = rounded_t + 15.minutes
    end
    
    until rounded_t > time_tomorrow_closing #Time.local(tomorrow.year, tomorrow.month, tomorrow.day, tomorrow_closing_time.split(':').first, tomorrow_closing_time.split(':').last)
      if rounded_t >= first_time_tomorrow
          delivery_time_options << {value: rounded_t.strftime("%H:%M"), text: "Tomorrow: #{rounded_t.strftime("%H:%M")}"} 
      end
      rounded_t = rounded_t + 15.minutes
    end


    delivery_time_options
  end



end
