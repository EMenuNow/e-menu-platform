class MoveStyleDataToThemeModel < ActiveRecord::Migration[6.0]
  def change
    Restaurant.find_each do |r|
      t = Theme.where(restaurant_id: r[:id]).first_or_initialize
      t.css_font_url = r.css_font_url
      t.custom_css = r.custom_css
      t.save
    end
  end
end
