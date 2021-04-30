class ChangeAmountToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :discount_codes, :amount, :float
  end
end
