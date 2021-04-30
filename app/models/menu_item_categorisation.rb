# frozen_string_literal: true

class MenuItemCategorisation < ApplicationRecord
  has_and_belongs_to_many :menus
  has_many :patron_allergens
end
