class OpeningTime < ApplicationRecord
  belongs_to :restaurant

  validates_uniqueness_of :restaurant_id, on: [:create, :update], message: "must be unique"
  validates_numericality_of :cut_off_days, on: [:create, :update], less_than: :advanced_order_days
  validates_numericality_of :advanced_order_days, on: [:create, :update], greater_than: :cut_off_days
  validates_numericality_of :max_orders, on: [:create, :update], greater_than_or_equal_to: 0





  def times_array
    sort_order = OpeningTime.days_of_week
    times.keys.sort_by {|m| sort_order.index m}
  end


  def self.kitchen_delay 
    [0,15,30,45,60]
  end

  def self.days_of_week
    ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
  end

  def self.available_times(step = 30)
      start = '00:00:00'
      time_end = '23:59:59'
      times = []
      (Time.parse('2020-08-01 00:00:00').to_i..Time.parse('2020-08-01 23:59:59').to_i).to_a.in_groups_of(step.minutes).collect(&:first).collect { |t| Time.at(t) } << Time.parse('2020-08-01 23:59:59')
  end


end
