require 'rubygems'
require 'yaml'
require 'json'

namespace :clone do

  desc "Custom List fix"
  task :custom_list_fix, [:restaurant_id] => [:environment] do |t, args|
    source_id = 3
    target_ids = [9,10]
    source_custom_lists = CustomList.where(restaurant_id: source_id)
    target_ids.each do |target_id|
      source_custom_lists.each do |source_custom_list|
        cl = CustomList.find_by(restaurant_id: target_id, name: source_custom_list.name)
        cl.cloned_from = source_custom_list.id
        cl.save
        scl = source_custom_list.custom_list_items
        cl.custom_list_items.each do |cl_item|
          cl_item.cloned_from = scl.select{|ol| ol.name == cl_item.name}.first.id
          cl_item.save
        end
      end
    end
  end

  desc "Custom List fix in menus"
  task :menus_custom_lists, [:restaurant_id] => [:environment] do |t, args|
    target_ids = [9,10]
    target_ids.each do |target_id|
      menus = Menu.where(restaurant_id: target_id)
      menus.each do |menu|
        menu.old_custom_lists = menu.custom_lists if menu.old_custom_lists.blank?
        menu.custom_lists.keys.each do |k|
          ncl = CustomList.find_by(restaurant_id: target_id, cloned_from: k.to_i)
          if ncl.present?
            menu.custom_lists[ncl.id.to_s] = menu.custom_lists.delete k
            menu.custom_lists[ncl.id.to_s].each do |cli|
              ncli = CustomListItem.find_by(custom_list_id: ncl.id, cloned_from: cli)
              if ncli.present?
                menu.custom_lists[ncl.id.to_s] = menu.custom_lists[ncl.id.to_s].map { |x| x == cli ? ncli.id.to_s : x }
              end
            end
          end
        end
        menu.save
      end
    end
  end

  # rails "clone:restaurant[clive+clone@clivebaker.com, cliveb1, nandozy, 3]"
  # rails "clone:restaurant[clive+clone5@clivebaker.com, cliveb1, nando_clive2, 3]"
	desc "Cloning Restaurant"
    task :restaurant, [:email, :password, :new_restaurant_name, :clone_restaurant_id] => [:environment] do |t, args|
      
      email = args[:email]
      password = args[:password]
      new_restaurant_name = args[:new_restaurant_name]
      clone_restaurant_id = args[:clone_restaurant_id]

      puts "Restaurant Clone"
      puts "user_name: #{email}"
      puts "password: #{password}"
      puts "new_restaurant_name: #{new_restaurant_name}"
      puts "clone_restaurant_id: #{clone_restaurant_id}"

      restaurant_user = RestaurantUser.find_or_create_by(email: email) do |user|
        user.password = password
        user.password_confirmation = password
      end

      existing_restaurant = Restaurant.find(clone_restaurant_id)

      new_restaurant = existing_restaurant.dup
      new_restaurant.restaurant_user_id = restaurant_user.id
      new_restaurant.path = new_restaurant_name
      new_restaurant.active_menu_ids = []
      new_restaurant.name = new_restaurant_name
      
      new_restaurant.save
      puts new_restaurant.errors.inspect

      CustomList.where(restaurant_id: clone_restaurant_id).each do |custom_list|
        new_custom_list = custom_list.dup
        new_custom_list.restaurant_id = new_restaurant.id
        new_custom_list.save
        custom_list.custom_list_items.each do |custom_list_item|
          new_custom_list_item = custom_list_item.dup
          new_custom_list_item.custom_list_id = new_custom_list.id
          new_custom_list_item.save
        end
      end

     roots = Menu.where(restaurant_id: clone_restaurant_id, ancestry: nil)
     roots.each do |root|
     root.clone_with_modifications_old!({'restaurant_id' => new_restaurant.id}, nil, :id)
    end

  end

  # rails "clone:menus_to_restaurant[3, 67]"
  desc "Clone Menus to Restaurant"
    task :menus_to_restaurant, [:restaurant_id, :receiver_restaurant_id] => [:environment] do |t, args|
      
      restaurant_id = args[:restaurant_id]
      receiver_id = args[:receiver_restaurant_id]
      
      # get restaurants
      existing_restaurant = Restaurant.find(restaurant_id)
      receiver_restaurant = Restaurant.find(receiver_id)

      # get existing custom lists
      existing_cls = CustomList.where(restaurant_id: existing_restaurant.id)
      cl_pairs = []
      cli_pairs = []
      
      # clone custom lists, adding pair to lookup table
      existing_cls.each do |cl|
        new_cl = cl.clone!(cl.id, receiver_restaurant.id)
        pair = {
          orig: cl.id.to_s,
          clone: new_cl.id.to_s
        }
        cl_pairs << pair

        # clone custom list items, adding pair to lookup table
        cl.custom_list_items.each do |cli|
          new_cli = cli.clone!(cli.id, new_cl.id)
          pair = {
            orig: cli.id.to_s,
            clone: new_cli.id.to_s
          }
          cli_pairs << pair
        end
      end

      # get each root menu, and clone
      roots = Menu.where(restaurant_id: restaurant_id, ancestry: nil)
      roots.each do |root|
        
        root_attributes = {
          'restaurant_id' => receiver_restaurant.id
        }
        
        clone = root.clone_with_modifications!(root_attributes, nil, :id, cl_pairs, cli_pairs)

    end
  end

end