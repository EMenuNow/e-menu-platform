class AddSpceLevelToCustomListItems < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_list_items, :spice_level_id, :bigint
  end
end
