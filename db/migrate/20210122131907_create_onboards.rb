class CreateOnboards < ActiveRecord::Migration[6.0]
  def change
    create_table :onboards do |t|
      t.references :restaurant_user, null: false, foreign_key: true
      t.boolean :tos_agreed
      t.datetime :tos_agreed_date
      t.string :tos_ver_agreed
      t.string :tos_ip
      t.text :tos_user_agent

      t.boolean :free_trial
      t.boolean :completed

      t.timestamps
    end
  end
end
