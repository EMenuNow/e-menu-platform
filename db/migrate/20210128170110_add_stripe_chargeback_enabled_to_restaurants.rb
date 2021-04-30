class AddStripeChargebackEnabledToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :stripe_chargeback_enabled, :boolean, :default => false
  end
end
