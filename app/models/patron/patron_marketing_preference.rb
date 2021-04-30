class Patron::PatronMarketingPreference < ApplicationRecord
  self.table_name = "patron_marketing_preferences"
  belongs_to :patron

end
