class CreateMenuItemCategorisationsCustomListItems < ActiveRecord::Migration[6.0]
  def change
    create_table :categorisations_clis do |t|
      t.belongs_to :custom_list_item
      t.belongs_to :menu_item_categorisation
      t.boolean :contains
      t.boolean :may_contain
      t.boolean :dietary
      t.boolean :category
    end
  end
end
