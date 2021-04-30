class CreatePatronAllergens < ActiveRecord::Migration[6.0]
  def change
    create_table :patron_allergens do |t|
      t.boolean :active
      t.belongs_to :allergen, null: false, foreign_key: true, index: true
      t.belongs_to :patron, null: false, foreign_key: true, index: true
    end
  end
end
