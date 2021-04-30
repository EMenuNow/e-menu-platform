class AddDiscountCodeToBasket < ActiveRecord::Migration[6.0]
  def change
    add_column :baskets, :discount_code, :string
  end
end
