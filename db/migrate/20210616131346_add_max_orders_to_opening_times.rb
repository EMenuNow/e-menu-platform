class AddMaxOrdersToOpeningTimes < ActiveRecord::Migration[6.0]
  def change
    add_column :opening_times, :max_orders, :integer, default: 0
    
    add_column :busy_times, :unavailable, :boolean, default: true
  end
end
