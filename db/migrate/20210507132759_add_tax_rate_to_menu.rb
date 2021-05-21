class AddTaxRateToMenu < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :tax_rate, :float, default: 0
    add_column :orders, :tax_rates, :jsonb
  end
end
