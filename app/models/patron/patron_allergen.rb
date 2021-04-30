class Patron::PatronAllergen < ApplicationRecord
  self.table_name = "patron_allergens"
  belongs_to :menu_item_categorisation
  belongs_to :patron

  
end
