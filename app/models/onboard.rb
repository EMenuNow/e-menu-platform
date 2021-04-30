class Onboard < ApplicationRecord
  belongs_to :restaurant_user

  validates_uniqueness_of :restaurant_user_id, on: [:create, :update], message: "must be unique"

end
