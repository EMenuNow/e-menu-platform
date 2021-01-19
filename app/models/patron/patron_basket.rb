class Patron::PatronBasket < ApplicationRecord
  self.table_name = "patron_baskets"
  belongs_to :patron, class_name: 'Patron'
  belongs_to :basket, class_name: 'Basket'
end
