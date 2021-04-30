class AddGroupOrderToReceiptsOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :group_order, :boolean
    add_column :receipts, :group_order, :boolean
  end
end
