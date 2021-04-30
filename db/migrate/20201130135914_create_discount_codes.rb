class CreateDiscountCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :discount_codes do |t|
      t.belongs_to :restaurant, null: false, foreign_key: true, index: true
      t.integer :amount
      t.string :type
      t.string :code
      t.integer :max_uses
      t.integer :used_times, :default => 0
      t.datetime :expires_on
      t.boolean :single_use_per_user
      t.timestamps
    end
  end
end
