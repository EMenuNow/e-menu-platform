class AddDueDateToOrdersAndReceipts < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :due_date, :datetime
    add_column :receipts, :due_date, :datetime
  end
end
