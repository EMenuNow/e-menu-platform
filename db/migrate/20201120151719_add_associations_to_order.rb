class AddAssociationsToOrder < ActiveRecord::Migration[6.0]
  def change
    create_join_table :orders, :patrons do |t|
      t.index :patron_id
      t.index :order_id
      t.timestamps null: false
    end

    add_reference :orders, :restaurant, null: false, foreign_key: true
    add_column :orders, :value, :integer
    add_column :orders, :currency, :string
  end

end
