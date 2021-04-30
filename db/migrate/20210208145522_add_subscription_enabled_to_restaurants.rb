class AddSubscriptionEnabledToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :subscription_enabled, :boolean, :default => true
  end
end
