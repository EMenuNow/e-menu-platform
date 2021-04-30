class Patron::PatronOrder < ApplicationRecord
  self.table_name = "patron_orders"
  belongs_to :patron, class_name: 'Patron'
  belongs_to :order, class_name: 'Order'
end
