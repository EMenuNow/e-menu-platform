class AddStripeConnectedAccountIdToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :stripe_connected_account_id, :string
  end
end
