class AddCheckoutFeatureToAllRestaurants < ActiveRecord::Migration[6.0]
  def change
    Restaurant.find_each do |r|
      r.features |= Feature.find([13])
    end
  end
end
