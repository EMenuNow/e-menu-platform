class CreateBusyTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :busy_times do |t|
      t.datetime :busy_time
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
