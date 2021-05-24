# frozen_string_literal: true

class MenuItemCategorisationsMenu < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item_categorisation

  scope :category, -> { where(category: true) }
  scope :contains_allergen, -> { where(contains: true) }
  scope :may_contain_allergen, -> { where(may_contain: true) }
  scope :dietary, -> { where(dietary: true) }
  scope :allergies, -> { where('contains=? OR may_contain=? OR dietary=?', true, true, true) }
end
