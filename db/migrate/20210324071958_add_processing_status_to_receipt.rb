class AddProcessingStatusToReceipt < ActiveRecord::Migration[6.0]
  def change
    add_column :receipts, :processing_status, :string, default: "pending"
  end
end
