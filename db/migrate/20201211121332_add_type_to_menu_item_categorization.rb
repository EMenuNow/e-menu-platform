class AddTypeToMenuItemCategorization < ActiveRecord::Migration[6.0]
  def change
    add_column :menu_item_categorisations, :type, :string, :default => "Allergen"
  end
end
