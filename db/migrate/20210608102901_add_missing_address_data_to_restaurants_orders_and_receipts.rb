class AddMissingAddressDataToRestaurantsOrdersAndReceipts < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :address_2, :string
    add_column :restaurants, :city, :string
    add_column :restaurants, :country_code, :string
    
    add_column :orders, :address_2, :string
    add_column :orders, :city, :string
    add_column :orders, :post_code, :string
    add_column :orders, :country_code, :string
    
    add_column :receipts, :address_2, :string
    add_column :receipts, :city, :string
    add_column :receipts, :post_code, :string
    add_column :receipts, :country_code, :string
  end
end
