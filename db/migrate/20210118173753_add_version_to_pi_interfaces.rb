class AddVersionToPiInterfaces < ActiveRecord::Migration[6.0]
  def change
    add_column :pi_interfaces, :version, :string
  end
end
