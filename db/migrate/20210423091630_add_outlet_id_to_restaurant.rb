class AddOutletIdToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :outletID, :string
  end
end
