class ChangeOrderDiscountCodeToBelongto < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :discount_code
    add_reference :orders, :discount_code, index: true
  end
end
