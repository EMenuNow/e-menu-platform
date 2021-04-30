class AddStripeDataToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :stripe_data, :json
    add_column :orders, :uuid, :string
    add_column :orders, :basket_total, :integer
    add_column :orders, :items, :jsonb
    add_column :orders, :stripe_token, :string
    add_column :orders, :status, :string
    add_column :orders, :is_ready, :boolean
    add_column :orders, :email, :string
    add_column :orders, :name, :string
    add_column :orders, :collection_time, :string
    add_column :orders, :telephone, :string
    add_column :orders, :address, :string
    add_column :orders, :delivery_or_collection, :string
    add_column :orders, :delivery_fee, :string
    add_column :orders, :table_number, :string
    add_column :orders, :discount_code, :string
  end
end
