class BusyTime < ApplicationRecord
  belongs_to :restaurant

  validates_presence_of :busy_time, on: :create, message: "can't be blank"
  validates_uniqueness_of :busy_time, on: [:create, :update], message: "must be unique"

  scope :in_future, -> { where("DATE(busy_time) >= ?", Date.today) }
end
