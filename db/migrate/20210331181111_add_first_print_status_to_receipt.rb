class AddFirstPrintStatusToReceipt < ActiveRecord::Migration[6.0]
  def change
    add_column :receipts, :first_print_status, :string
  end
end
