class ReconfigureAllergensCategoriesAndDietary < ActiveRecord::Migration[6.0]
  def change

    add_column :menu_item_categorisations_menus, :id, :primary_key
    add_column :menu_item_categorisations_menus, :contains, :boolean
    add_column :menu_item_categorisations_menus, :may_contain, :boolean
    add_column :menu_item_categorisations_menus, :dietary, :boolean
    add_column :menu_item_categorisations_menus, :category, :boolean

  end
end
