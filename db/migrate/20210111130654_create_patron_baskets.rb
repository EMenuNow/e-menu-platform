class CreatePatronBaskets < ActiveRecord::Migration[6.0]
  def change
    create_table :patron_baskets do |t|
      t.references :patron, null: false, foreign_key: true
      t.references :basket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
