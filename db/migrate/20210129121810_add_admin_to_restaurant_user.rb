class AddAdminToRestaurantUser < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurant_users, :admin, :boolean, :default => false
  end
end
