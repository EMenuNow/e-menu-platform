class CreateMenuTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :menu_times do |t|
      t.references :menu, null: false, foreign_key: true
      t.jsonb :times

      t.timestamps
    end
  end
end
