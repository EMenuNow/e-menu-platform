class AddCutOffDaysAndAdvancedOrderDaysToOpeningTimes < ActiveRecord::Migration[6.0]
  def change
    add_column :opening_times, :cut_off_days, :integer, default: 0
    add_column :opening_times, :advanced_order_days, :integer, default: 2
  end
end
