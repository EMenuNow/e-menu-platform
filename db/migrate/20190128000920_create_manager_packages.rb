class CreateManagerPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :name

      t.timestamps
    end
  end
end
