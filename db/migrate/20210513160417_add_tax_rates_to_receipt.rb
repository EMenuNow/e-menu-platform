class AddTaxRatesToReceipt < ActiveRecord::Migration[6.0]
  def change
    add_column :receipts, :tax_rates, :jsonb
  end
end
