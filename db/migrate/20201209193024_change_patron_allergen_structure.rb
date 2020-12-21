class ChangePatronAllergenStructure < ActiveRecord::Migration[6.0]
  def change
    remove_column :patron_allergens, :allergen_id
    add_reference :patron_allergens, :menu_item_categorisation, index: true, null: false
    drop_table :allergens

    MenuItemCategorisation.update_all(:type=>"Allergen")
  end
end
