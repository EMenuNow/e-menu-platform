class CreateJoinTableRestaurantPatron < ActiveRecord::Migration[6.0]
  def change
    create_join_table :restaurants, :patrons do |t|
      t.index [:restaurant_id, :patron_id], unique: true
      t.index [:patron_id, :restaurant_id], unique: true
    end
  end
end
