# frozen_string_literal: true

class Menu < ApplicationRecord
  belongs_to :restaurant
  belongs_to :item_screen_type, optional: true



  belongs_to :spice_level, optional: true

  before_save :set_root_node_id
  after_save :clear_cache
  default_scope {where(is_deleted: false)}

  scope :live_menus, -> { where(is_deleted: false, available: true) }

  delegate :name, :key, to: :item_screen_type, prefix: true, allow_nil: true

  def set_root_node_id
    self.root_node_id = root.id
  end

def clear_cache
  # binding.pry
  Rails.cache.delete("api/restaurant/#{restaurant_id}/menu")
  Rails.cache.delete("restaurant_order_menu_#{restaurant_id}")
end

def secondary_item_screen_type
  ItemScreenType.find(secondary_item_screen_type_id) if secondary_item_screen_type_id.present?
end
def secondary_item_screen_type_name
  secondary_item_screen_type.name if secondary_item_screen_type.present?
end
def secondary_item_screen_type_key
  secondary_item_screen_type.key if secondary_item_screen_type.present?
end






  # belongs_to :menu_item_categorisation, optional: true
  has_and_belongs_to_many :menu_item_categorisation
  has_and_belongs_to_many :cook_level

  has_ancestry

  has_one_attached :image
  validates :image, size: { less_than: 2.megabytes, message: 'is more than 2 megabytes'},
                    content_type: { in: ['image/png', 'image/jpg'], message: 'is not a png or jpg' }

  translates :name, :description, fallbacks_for_empty_translations: true

  validates_presence_of :name, on: %i[update create], message: "can't be blank"
  # validates_presence_of :description, on: %i[update create], message: "can't be blank", if: :node?
  validates_presence_of :price_a, on: %i[update create], message: "can't be blank", if: :node?
  validates_numericality_of :price_a, on: :create, message: 'is not a number', if: :node?
  #   validates_numericality_of :price_b, :on => :create, :message => "is not a number", if: :node?

  delegate :name, to: :spice_level, prefix: true, allow_nil: true
  delegate :name, to: :cook_level, prefix: true, allow_nil: true
  delegate :features, to: :restaurant, prefix: true, allow_nil: true
  delegate :feature_ids, to: :restaurant, prefix: true, allow_nil: true
 
  delegate :id, to: :restaurant, prefix: true, allow_nil: false

  def node?
    node_type == 'item'
  end

  def prices_joined
    pri = []
    pri << price_a if price_a
    #      pri << price_b if price_b
    pri
  end

  def translate
    # TranslateJob.perform_later self
  end




  def clone_with_modifications!(attributes = nil, parent = nil, original_id_field_name = nil)
    #binding.pry
    clone = self.class.create!(self.attributes.merge('id' => nil).merge('ancestry' => nil).merge(attributes))
    # clone.send("#{original_id_field_name}=", self.id) if original_id_field_name
    clone.parent = parent
    self.children.each { |child| child.clone_with_modifications!(attributes, clone, original_id_field_name) }
    clone.save!
    clone
  end



end
