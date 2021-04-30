class Theme < ApplicationRecord
  belongs_to :restaurant

  validates_uniqueness_of :restaurant_id, on: [:create, :update], message: "must be unique"

  def colors_set?
    color_primary.present? && color_secondary.present?
  end

end
