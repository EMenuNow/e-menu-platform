class AddOrderIdToReceipts < ActiveRecord::Migration[6.0]
  def change
    add_reference :receipts, :order, null: true, foreign_key: true, index: true

    change_column_null :receipts, :order_id, true
  end
end
