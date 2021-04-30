class AddAvailableToCustomListItems < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_list_items, :available, :boolean, :default => true
  end
end
