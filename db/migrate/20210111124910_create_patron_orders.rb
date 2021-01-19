class CreatePatronOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :patron_orders do |t|
      t.references :patron, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
