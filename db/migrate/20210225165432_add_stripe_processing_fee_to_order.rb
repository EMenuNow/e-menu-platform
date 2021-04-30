class AddStripeProcessingFeeToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :stripe_processing_fee, :integer
    add_column :receipts, :stripe_processing_fee, :integer
  end
end
