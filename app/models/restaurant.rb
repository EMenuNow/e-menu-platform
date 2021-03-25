# frozen_string_literal: true

class Restaurant < ApplicationRecord
  belongs_to :cuisine

  belongs_to :restaurant_user
  has_one :opening_time
  has_one :theme
  has_many :delivery_postcodes
  has_many :receipts
  has_many :menus
  belongs_to :currency
  has_many :restaurant_tables
  has_many :discount_codes
  has_many :custom_lists, -> { order(position: :asc) }
  has_and_belongs_to_many :features, -> { distinct }
  has_and_belongs_to_many :template

  # has_many :tables, through: :restaurant_tables

  validates_presence_of :name, on: %i[create update], message: "can't be blank"
  validates_presence_of :address, on: %i[create update], message: "can't be blank"
  validates_presence_of :postcode, on: %i[create update], message: "can't be blank"
  validates_presence_of :telephone, on: %i[create update], message: "can't be blank"
  validates_presence_of :email, on: %i[create update], message: "can't be blank"
  validates_uniqueness_of :path, on: %i[create update], message: "must be unique"
  validates_uniqueness_of :restaurant_user_id, on: %i[create update], message: "must be unique"
  validates :commision_percentage, :inclusion => { :in => 0..10, message: "must be between 0% and 10%" }
  validates :image, size: { less_than: 2.megabytes, message: 'is more than 2 megabytes'},
                    content_type: { in: ['image/png', 'image/jpg'], message: 'is not a png or jpg' }

  delegate :name, to: :cuisine, prefix: true
  delegate :ids, to: :features, prefix: true
  delegate :live_menus, to: :menus, prefix: true
  delegate :times, :delay_time_minutes, :kitchen_delay_minutes, to: :opening_time, prefix: true
  delegate :color_primary, :color_secondary, :css_font_url, :font_primary, :font_weight_primary, :text_transform_primary, :font_style_primary, :font_secondary, :font_weight_secondary, :text_transform_secondary, :font_style_secondary, :dark_theme, :custom_css, to: :theme, prefix: true
  delegate :name, :code, :symbol, to: :currency, prefix: true

  before_create :set_slug

  after_create :default_features
  after_create :default_theme

  has_one_attached :image
  has_one_attached :background_image

  def background
    if subtle_background.present? and subtle_background != 'None'
      back = "/background/#{subtle_background}.png"
    end
  end

  def time_zone
    currency.code == 'cad' ? 'America/Toronto' : 'Europe/London'
  end

  def stripe_sk_api_key
    if stripe_chargeback_enabled
      Rails.env == 'production' ? ENV['STRIPE_PRO_API_KEY'] : 'sk_test_51IEEKiJyyGTIkLikMKhhmkTY4raz9JHFXp9qiQYwvJNRviHXdBqwpIez4Kva9vtbw6iMaT5qZML5vvGAK1n71i0c0013EXKJPf'
    else
      Rails.env == 'production' ? ENV['STRIPE_API_KEY'] : 'sk_test_hOj5WqYB26UV1v5uuqXsADSG'
    end
  end
  
  def stripe_pk_api_key
    if stripe_chargeback_enabled
      Rails.env == 'production' ? ENV['STRIPE_PRO_PK_API_KEY'] : 'pk_test_51IEEKiJyyGTIkLikJM25yV1oCLrbVhvDwWRXfvtDG3AZlXWvMmzusQQLUajhKyHezbGugPkI25j1qGCYIlwddvBq00lYPYNmZn'
    else
      Rails.env == 'production' ? ENV['STRIPE_PK_API_KEY'] : 'pk_test_WK72bUcdjoVsncoNFQGrFkcv'
    end
  end  
    
  def set_slug
    if slug.blank? 
      token_chars = ('A'..'Z').to_a.delete_if { |i| i == 'O' } + ('1'..'9').to_a
      token_length = 6
      self.slug = Array.new(token_length) { token_chars[rand(token_chars.length)] }.join
    end
  end

  def is_open
    t = Time.new.in_time_zone(time_zone)
    today_day = t.strftime("%A").downcase
    today_opening_time = opening_time_times[today_day]['open']
    today_closing_time = opening_time_times[today_day]['close']
    today_opening_time = "00:00" if today_opening_time.empty?
    today_closing_time = "00:00" if today_closing_time.empty?
    time_today_opening = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_opening_time}:00") - t.utc_offset
    time_today_closing = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_closing_time}:00") - t.utc_offset - opening_time_kitchen_delay_minutes.minutes
    time_today_opening = time_today_opening.in_time_zone(time_zone)
    time_today_closing = time_today_closing.in_time_zone(time_zone)
    time_today_opening < t and t < time_today_closing
  end
  def is_closing(notice = 0)
    t = Time.new.in_time_zone(time_zone)
    today_day = t.strftime("%A").downcase
    today_opening_time = opening_time_times[today_day]['open']
    today_closing_time = opening_time_times[today_day]['close']
    today_opening_time = "00:00" if today_opening_time.empty?
    today_closing_time = "00:00" if today_closing_time.empty?
    time_today_opening = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_opening_time}:00") - t.utc_offset
    time_today_closing = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_closing_time}:00") - t.utc_offset - opening_time_kitchen_delay_minutes.minutes
    time_today_opening = time_today_opening.in_time_zone(time_zone)
    time_today_closing = time_today_closing.in_time_zone(time_zone)
    
    
    ((time_today_closing - t)/60).to_i
    
  end
  
  
  
  def available_times
    # Delay time minutes
    dtm = opening_time_delay_time_minutes.minutes
    dtm = 30.minutes if dtm.blank?
    
    # Busy time minutes
    btm = opening_time_kitchen_delay_minutes.minutes
    
    t = Time.new.in_time_zone(time_zone)
    tomorrow = Time.new.in_time_zone(time_zone) + 1.day
    #  binding.pry
    # rounded_t = Time.local(t.year, t.month, t.day, t.hour, t.min/15*15)
    round_down_t = Time.parse("#{t.year}-#{t.month}-#{t.day} #{t.hour}:#{t.min/15*15}:00")
    rounded_t = round_down_t + 15.minutes
    
    delivery_time_options = []
    
    today_day = t.strftime("%A").downcase
    tomorrow_day = (tomorrow).strftime("%A").downcase
    today_opening_time = opening_time_times[today_day]['open']
    today_closing_time = opening_time_times[today_day]['close']
    # time_today_opening = Time.local(t.year, t.month, t.day, today_opening_time.split(':').first, today_opening_time.split(':').last)
    # time_today_opening = Time.local(t.year, t.month, t.day, today_opening_time.split(':').first, today_opening_time.split(':').last)
    
    time_today_opening = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_opening_time}:00")
    time_today_closing = Time.parse("#{t.year}-#{t.month}-#{t.day} #{today_closing_time}:00")
    
    delivery_time_options << {value: "ASAP", text: "ASAP"} if is_open and (round_down_t + dtm < today_closing_time) 
    
    
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

  def clear_kitchen_delay
    self.opening_time.update(kitchen_delay_minutes: 0)
  end

  private

  def default_features
    self.features |= Feature.find([1,8,13])
    # 1 = Images
    # 8 = Menu in Sections
    # 13 = Checkout
  end

  def default_theme
    theme = Theme.new
    theme.restaurant_id = self.id
    theme.color_primary = '#FFFFFF'
    theme.color_secondary = '#182627'
    
    theme.css_font_url = 'https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;700&family=Raleway:wght@200;300&display=swap'
    
    theme.font_primary = 'Open Sans, Sans-Serif'
    theme.font_weight_primary = 300
    theme.text_transform_primary = 'none'
    theme.font_style_primary = 'none'

    theme.font_secondary = 'Raleway, sans-serif'
    theme.font_weight_secondary = 200
    theme.text_transform_secondary = 'none'
    theme.font_style_secondary = 'none'

    theme_css = File.read("#{Rails.root}/app/assets/stylesheets/restaurant/default_theme.css")

    theme.custom_css = theme_css

    theme.save
  end

end
