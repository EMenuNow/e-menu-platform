class AddCommisionPercentageToRestaurant < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :commision_percentage, :float, default: 0
  end
end
