class AddPatronDetailsToPatrons < ActiveRecord::Migration[6.0]
  def change
    add_column :patrons, :full_name, :string
    add_column :patrons, :phone, :string

    create_table :patron_marketing_preferences do |t|
      t.belongs_to :patron, null: false, foreign_key: true, index: true
      t.boolean :emenu_news
      t.boolean :emenu_promotions
      t.boolean :restaurant_news
      t.boolean :restaurant_promotions

      t.timestamps
    end
    Patron.all.map{|x|x.create_patron_marketing_preference}

    create_table :patron_addresses do |t|
      t.belongs_to :patron, null: false, foreign_key: true, index: true
      t.boolean :house_number
      t.boolean :street
      t.boolean :postcode
      t.boolean :country

      t.timestamps
    end
  end
end
