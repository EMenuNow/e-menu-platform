class Patron::PatronAddress < ApplicationRecord
  self.table_name = "patron_addresses"
  belongs_to :patron

end
