class Basket < ApplicationRecord
  has_many :patron_baskets, class_name: 'Patron::PatronBasket'
  has_many :patrons, through: :patron_baskets
end
