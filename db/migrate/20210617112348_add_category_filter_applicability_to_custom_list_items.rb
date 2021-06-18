class AddCategoryFilterApplicabilityToCustomListItems < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_list_items, :category_filtered, :boolean, default: false
  end
end
