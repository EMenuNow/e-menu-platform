class CreateRefunds < ActiveRecord::Migration[6.0]
  def change
    create_table :refunds do |t|
      t.belongs_to :order
      t.jsonb :stripe_data
      t.timestamps
    end
  end
end
