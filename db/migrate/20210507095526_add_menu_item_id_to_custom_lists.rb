class AddMenuItemIdToCustomLists < ActiveRecord::Migration[6.0]
  def change
    add_column :menus, :menuID, :string
    add_column :menus, :menuItemGroupID, :string
    add_column :custom_lists, :menuItemID, :string

    create_table :menu_item_taxes do |t|
      t.integer :remoteOrderTaxID
      t.string :inclusiveTaxPerUnit
      t.float :exclusiveTaxPerUnit
      t.float :taxableSalesPerUnit

      t.timestamps
    end
  end
end
