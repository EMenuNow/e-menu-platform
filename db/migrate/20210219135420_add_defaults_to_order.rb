class AddDefaultsToOrder < ActiveRecord::Migration[6.0]
  def change
    change_column_default :orders, :basket_total, 0
    change_column_default :receipts, :basket_total, 0
    change_column_default :orders, :value, 0
    change_column_default :orders, :delivery_fee, "0"
    change_column_default :receipts, :delivery_fee, 0
  end
end
