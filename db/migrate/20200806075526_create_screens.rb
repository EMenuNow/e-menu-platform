class CreateScreens < ActiveRecord::Migration[5.2]
  def change

    ItemScreen.delete_all
    item_screen_type = ItemScreenType.find_by(key: 'FULL')

    Restaurant.all.each do |restaurant|
      puts restaurant.id
      puts isc = ItemScreen.create(restaurant_id: restaurant.id, item_screen_type_id: item_screen_type.id, printer_id: nil, on_new: false, buzz_on_new: false)
      puts isc.inspect
      puts isc.errors
      puts "--------------------------------"

    end

  end
end
