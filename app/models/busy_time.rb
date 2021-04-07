class BusyTime < ApplicationRecord
  belongs_to :restaurant

  validates_presence_of :busy_time, on: :create, message: "can't be blank"

  scope :in_future, -> { where("DATE(busy_time) >= ?", Date.today) }
end
