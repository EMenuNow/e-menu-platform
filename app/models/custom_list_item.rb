class CustomListItem < ApplicationRecord
  belongs_to :custom_list
  belongs_to :spice_level, optional: true

  has_many :categorisations_clis
  has_many :menu_item_categorisations, through: :categorisations_clis

  validates_presence_of :price, :on => [:create, :update], :message => "please include a price or 0 for no price"
  delegate :name, to: :custom_list, prefix: true

  def clone!(cli_id, cl_id)
    custom_list_item = CustomListItem.find(cli_id)
    new_custom_list = CustomList.find(cl_id)

    new_custom_list_item = custom_list_item.dup
    new_custom_list_item.custom_list_id = new_custom_list.id
    new_custom_list_item.save
    custom_list_item.categorisations_clis.each{|c| c.clone!(c.id, new_custom_list_item.id)}
    new_custom_list_item
  end
end
