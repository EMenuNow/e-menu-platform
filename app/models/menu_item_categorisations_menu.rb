# frozen_string_literal: true

class MenuItemCategorisationsMenu < ApplicationRecord
  belongs_to :menu
  belongs_to :menu_item_categorisation

  scope :category, -> { where(category: true) }
  scope :contains_allergen, -> { where(contains: true) }
  scope :may_contain_allergen, -> { where(may_contain: true) }
  scope :dietary, -> { where(dietary: true) }
  scope :allergies, -> { where('contains=? OR may_contain=? OR dietary=?', true, true, true) }

  def clone!(cat_id, menu_id)
    categorisation = MenuItemCategorisationsMenu.find(cat_id)
    new_menu = Menu.find(menu_id)

    new_categorisation = categorisation.dup
    new_categorisation.menu_id = new_menu.id
    new_categorisation.save
    new_categorisation
  end
end
