# frozen_string_literal: true

class Menu < ApplicationRecord
  belongs_to :restaurant
  belongs_to :item_screen_type, optional: true
  belongs_to :spice_level, optional: true

  has_one :menu_time, dependent: :destroy
  has_many :menu_item_categorisations_menus
  has_many :menu_item_categorisations, through: :menu_item_categorisations_menus
  has_and_belongs_to_many :cook_level
  has_one_attached :image

  has_ancestry
  
  validates_presence_of :name, on: %i[update create], message: "can't be blank"
  # validates_presence_of :description, on: %i[update create], message: "can't be blank", if: :node?
  validates_presence_of :price_a, on: %i[update create], message: "can't be blank", if: :node?
  validates_numericality_of :price_a, on: :create, message: 'is not a number', if: :node?
  #   validates_numericality_of :price_b, :on => :create, :message => "is not a number", if: :node?
  validates :image, size: { less_than: 2.megabytes, message: 'is more than 2 megabytes'},
  content_type: { in: ['image/png', 'image/jpeg'], message: 'is not a png or jpg' }

  delegate :name, :key, to: :item_screen_type, prefix: true, allow_nil: true
  delegate :name, to: :spice_level, prefix: true, allow_nil: true
  delegate :name, to: :cook_level, prefix: true, allow_nil: true
  delegate :features, to: :restaurant, prefix: true, allow_nil: true
  delegate :feature_ids, to: :restaurant, prefix: true, allow_nil: true
  delegate :id, to: :restaurant, prefix: true, allow_nil: false
  delegate :times, to: :menu_time, prefix: true, allow_nil: false

  before_save :set_root_node_id
  after_save :clear_cache
  
  default_scope {where(is_deleted: false)}
  scope :live_menus, -> { where(is_deleted: false, available: true) }
    
  translates :name, :description, fallbacks_for_empty_translations: true

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

  def is_available?
    return false if !restaurant.active_menu_ids.include?(self.id)
    return restaurant.active_menu_ids.include?(self.id) if !self.menu_time

    t = Time.new.in_time_zone(self.restaurant.time_zone)
    today_day = t.strftime("%A").downcase
    today_start_time = self.menu_time_times[today_day]['start']
    today_end_time = self.menu_time_times[today_day]['end']
    today_start_time = "00:00" if today_start_time.empty?
    today_end_time = "00:00" if today_end_time.empty?
    time_today_start = Time.zone.parse("#{t.year}-#{t.month}-#{t.day} #{today_start_time}:00") - t.utc_offset
    time_today_end = Time.zone.parse("#{t.year}-#{t.month}-#{t.day} #{today_end_time}:00") - t.utc_offset
    time_today_start = time_today_start.in_time_zone(self.restaurant.time_zone)
    time_today_end = time_today_end.in_time_zone(self.restaurant.time_zone)
    time_today_start < t and t < time_today_end
  end

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

  def clone_with_modifications!(attributes = nil, parent = nil, original_id_field_name = nil, cl_pairs = nil, cli_pairs = nil)
    new_cl_map = {}
    custom_lists.each do |cl|
      new_cl = cl_pairs.select{|cl_pair| cl_pair[:orig] == cl[0]}.first[:clone]
      new_clis = cl[1].map {|cli| cli_pairs.select{|cli_pair| cli_pair[:orig] == cli}.first[:clone]}
      new_cl_map["#{new_cl}"] = new_clis
    end if custom_lists.any?
    
    clone = self.class.create!(self.attributes.merge('id' => nil).merge('ancestry' => nil).merge(attributes).merge('custom_lists' => new_cl_map))
    clone.parent = parent
    self.children.each { |child| child.clone_with_modifications!(attributes, clone, original_id_field_name, cl_pairs, cli_pairs) }
    clone.menu_time = menu_time if menu_time
    clone.image.attach(image.blob) if image.attached?

    self.menu_item_categorisations_menus.each{|c| c.clone!(c.id, clone.id)}
    clone.save!
    clone
  end

  def clone_with_modifications_old!(attributes = nil, parent = nil, original_id_field_name = nil)
    #binding.pry
    clone = self.class.create!(self.attributes.merge('id' => nil).merge('ancestry' => nil).merge(attributes))
    # clone.send("#{original_id_field_name}=", self.id) if original_id_field_name
    clone.parent = parent
    self.children.each { |child| child.clone_with_modifications_old!(attributes, clone, original_id_field_name) }
    clone.save!
    clone
  end

end
