class ExistingCustomListItemFilteringApplicability < ActiveRecord::Migration[6.0]
  def change
    clis = CustomListItem.includes(:categorisations_clis).where.not(categorisations_clis: {menu_item_categorisation: nil}).where('contains=? OR may_contain=? OR dietary=?', true, true, true)
    clis.update_all(category_filtered: true)
  end
end
