# frozen_string_literal: true

module MenusHelper
  # def node(menu)
  #   return_string = ''
  #   return_string << '<ul>'
  #   menu.children.each do |menu|
  #     return_string << "<li data-jstree='{\"opened\":#{menu.id == @updated_menu}, \"selected\":#{menu.id == @updated_menu}, \"icon\":\"fa fa-clone\"}' data-restaurant_id='#{menu.restaurant_id}' data-menu_id='#{menu.id}' data-node_type='#{menu.node_type}' data-parent='#{menu.id}'>#{menu.name}"
  #     return_string << node(menu) if menu.has_children?
  #     return_string << ' </li>'
  #   end
  #   return_string << '</ul>'
  # end

  def get_menu_image(item_id)
    begin
      m = Menu.find(item_id)
      m.image if m.image.attached?
    rescue
    end
  end

  def get_menu_item_name(menu_id)
    name = ''
    begin
      m = Menu.find(menu_id)
      name = m.name
    rescue
    end
    name
  end

  def checked?(menu_custom_lists, custom_list_id, item_id)
    checked = ""
    if menu_custom_lists[custom_list_id.to_s].present?
      checked = menu_custom_lists[custom_list_id.to_s].include?(item_id.to_s) ? "CHECKED" : ""
    end
    checked
  end

  def custom_list_items(items)
    Rails.cache.fetch("custom_list_items-#{items.join('-')}-", expires_in: 3.hours) do
      CustomListItem.where(id: items).map{|g| g.name}.join(", ")
    end
  end

  def custom_list(id)
    Rails.cache.fetch("custom_list_name_#{id}", expires_in: 3.hours) do
      CustomList.find(id).name
    end
  end

  def custom_list_object(id)
    Rails.cache.fetch("custom_list_#{id}", expires_in: 3.hours) do
      CustomList.find(id)
    end
  end

  def custom_list_item(id)
    Rails.cache.fetch("custom_list_item_#{id}", expires_in: 3.hours) do
      CustomListItem.find(id)
    end
  end
  
  def custom_list_constraint(key)
    Rails.cache.fetch("custom_list_constraint_#{key}", expires_in: 3.hours) do
      constraint_to_human CustomList.find(key).constraint
    end
  end

end
