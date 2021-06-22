class AddPrintStatusToReceipts < ActiveRecord::Migration[6.0]
  def change
    add_column :receipts, :print_status, :string
  end
end
