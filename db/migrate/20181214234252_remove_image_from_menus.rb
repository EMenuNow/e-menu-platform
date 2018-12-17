# frozen_string_literal: true

class RemoveImageFromMenus < ActiveRecord::Migration[5.2]
  def change
    remove_column :menus, :image
  end
end
