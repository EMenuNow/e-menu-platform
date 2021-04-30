class AddDiscountCodeToReceipt < ActiveRecord::Migration[6.0]
  def change
    add_reference :receipts, :discount_code, foreign_key: true, index: true
  end
end
