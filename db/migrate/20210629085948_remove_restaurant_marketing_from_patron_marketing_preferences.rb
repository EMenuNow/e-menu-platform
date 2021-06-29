class RemoveRestaurantMarketingFromPatronMarketingPreferences < ActiveRecord::Migration[6.0]
  def change
    remove_column :patron_marketing_preferences, :restaurant_news
    remove_column :patron_marketing_preferences, :restaurant_promotions
  end
end
