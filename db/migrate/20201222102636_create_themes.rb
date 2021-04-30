class CreateThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :themes do |t|
      t.references :restaurant, null: false, foreign_key: true

      t.string :color_primary
      t.string :color_secondary
      
      t.string :css_font_url
      
      t.string :font_primary
      t.integer :font_weight_primary
      t.string :text_transform_primary
      t.string :font_style_primary
      
      t.string :font_secondary
      t.integer :font_weight_secondary
      t.string :text_transform_secondary
      t.string :font_style_secondary
      
      t.boolean :dark_theme
      
      t.text :custom_css

      t.timestamps
    end
  end
end
