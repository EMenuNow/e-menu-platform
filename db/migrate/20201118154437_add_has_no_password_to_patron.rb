class AddHasNoPasswordToPatron < ActiveRecord::Migration[6.0]
  def change
    add_column :patrons, :has_no_password, :boolean, :default => false
  end
end
