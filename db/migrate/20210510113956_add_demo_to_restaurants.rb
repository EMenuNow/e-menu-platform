class AddDemoToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :demo, :boolean, default: false
  end
end
