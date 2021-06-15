class CustomListItem < ApplicationRecord
  belongs_to :custom_list
  belongs_to :spice_level, optional: true

  has_many :categorisations_clis
  has_many :menu_item_categorisations, through: :categorisations_clis

  validates_presence_of :price, :on => [:create, :update], :message => "please include a price or 0 for no price"
  delegate :name, to: :custom_list, prefix: true
end
