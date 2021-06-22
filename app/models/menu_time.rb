class MenuTime < ApplicationRecord
  belongs_to :menu

  validates_uniqueness_of :menu_id, on: [:create, :update], message: "must be unique"

  def times_array
    sort_order = MenueTime.days_of_week
    times.keys.sort_by {|m| sort_order.index m}
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

  def blank_times
    blank = {
      "monday": {
        "start": "",
        "end": ""
      },
      "tuesday": {
        "start": "",
        "end": ""
      },
      "wednesday": {
        "start": "",
        "end": ""
      },
      "thursday": {
        "start": "",
        "end": ""
      },
      "friday": {
        "start": "",
        "end": ""
      },
      "saturday": {
        "start": "",
        "end": ""
      },
      "sunday": {
        "start": "",
        "end": ""
      }
    }
  end

end
