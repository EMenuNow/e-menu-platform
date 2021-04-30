class CreateAllergens < ActiveRecord::Migration[6.0]
  def change
    create_table :allergens do |t|
      t.string :title, null: false
      t.string :description, null: false
    end

    ["gluten", "celery", "tree_nuts", "fish", "soy",
    "sesame", "peanuts", "crustaceans", "eggs",
    "molluscs", "milk", "mustard", "sulphur_dioxide_sulphates", "lupin"].each do |aa|
      Allergen.create(:title=>aa, :description=>aa)
    end
  end
end
