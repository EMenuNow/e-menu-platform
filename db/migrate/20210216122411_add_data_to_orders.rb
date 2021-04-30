class AddDataToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :application_fee_amount, :integer, :default => 0
    add_column :receipts, :application_fee_amount, :integer, :default => 0
    add_column :orders, :emenu_commission, :integer, :default => 0
    add_column :receipts, :emenu_commission, :integer, :default => 0
    add_column :orders, :chargeback_fee, :integer, :default => 0
    add_column :receipts, :chargeback_fee, :integer, :default => 0
    add_column :orders, :chargeback_enabled, :boolean, :default => false
    add_column :receipts, :chargeback_enabled, :boolean, :default => false
    add_column :orders, :emenu_vat_charge, :integer, :default => 0
    add_column :receipts, :emenu_vat_charge, :integer, :default => 0
  end
end
