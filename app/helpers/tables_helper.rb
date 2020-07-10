# frozen_string_literal: true

module TablesHelper

  def get_list_names(ids)

    cl = CustomList.where(id: ids)
    names = cl.map{|n| n.name}  
    names.join(" and ")
  
  end

  def custom_list_options(custom_lists, constraints = [])
    valid_list_found = false
    ret_string = "<strong>#{t('menu.choose_below')}</strong><br>"
    custom_lists.keys.each do |custom_list_key| 
      custom_list =  CustomList.find(custom_list_key)
      if constraints.include?(custom_list.constraint)
          valid_list_found = true
          checkbox_list = ""
          CustomListItem.where(id: custom_lists[custom_list_key]).each do |item| 
            checkbox_list += %Q(
                <div class="collection-check-box">
                  <input type="#{custom_list.input_type}" value="#{item.id}" name="table[custom_lists][#{custom_list.id}][]" id="menu_custom_lists_#{custom_list.id}-#{item.id}", class="custom_list_option" >
                  <i class="">#{item.name} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #{number_to_currency(item.price, unit: "£") if item.price > 0}</i>
                </div>
             )
          end 
          ret_string += %Q(
           <div class="row mb-2">
           <div class="col">
             <strong>#{custom_list.name}</strong>  (#{constraint_to_human(custom_list.constraint)})
              #{checkbox_list}
           </div>
           </div>)
        end
      end
    if valid_list_found
      ret_string
    else   
      ""
    end
  end




  def custom_list_options2(custom_lists, constraints = [])
    valid_list_found = false
    ret_string = "<strong>#{t('menu.choose_below')}</strong><br>"
    custom_lists.keys.each do |custom_list_key| 
      custom_list =  CustomList.find(custom_list_key)
      if constraints.include?(custom_list.constraint)
          valid_list_found = true
          checkbox_list = ""
          CustomListItem.where(id: custom_lists[custom_list_key]).each do |item| 
            checkbox_list += %Q(
                <div class="collection-check-box">
                  <input type="#{custom_list.input_type}" value="#{item.id}" name="table[custom_lists][#{custom_list.id}][]" id="menu_custom_lists_#{custom_list.id}-#{item.id}", class="custom_list_option" >
                  <i class="">#{item.name} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #{number_to_currency(item.price, unit: "£") if item.price > 0}</i>
                </div>
             )
             checkbox_list += %Q(
                <div class="custom-control custom-checkbox">
                  <input type="#{custom_list.input_type}"  value="#{item.id}" name="table[custom_lists][#{custom_list.id}][]" class="custom_list_option" id="menu_custom_lists_#{custom_list.id}-#{item.id}">
                  <label class="custom-control-label pt-1 checkout" for="menu_custom_lists_#{custom_list.id}-#{item.id}">>#{item.name} --> #{number_to_currency(item.price, unit: "£") if item.price > 0}</label>
                </div>
             )



          end 
          ret_string += %Q(
           <div class="row mb-2">
           <div class="col">
             <strong>#{custom_list.name}</strong>  (#{constraint_to_human(custom_list.constraint)})
              #{checkbox_list}
           </div>
           </div>)
        end
      end
    if valid_list_found
      ret_string
    else   
      ""
    end
  end

      

    #   <%=sub.custom_lists%>
    #   <% list['items'].each do |item| %>
    #     <% if list['constraint'] == '*' %>
    #       <div class="row m-2 p-1 border">
    #         <div class='col'>
    #           <%= check_box_tag "item-#{item['id']}", "item-#{item['id']}", nil, class: "selection-item selection-item-#{main_item}", 'data-price' => ("%.2f" % item['price']).to_f, 'data-start_price' => start_price, 'data-scope' => main_item, 'data-id' => item['id']  %> <small><%=item['name']%></small>
    #         </div>
    #         <div class='col-4 text-right'>
    #           <small><%=number_to_currency(item['price'], unit: '+£') if item['price'].to_f > 0.0 %></small>
    #         </div>
    #       </div>
    #     <% else %>
    #       <div class="row m-2 p-1 border">
    #         <div class='col'>
    #           <%= radio_button_tag "item-#{list['custom_list_id']}", "item-#{list['custom_list_id']}", nil, 'data-price' => ("%.2f" % item['price']).to_f ,class: "selection-item selection-item-radio-#{main_item}", 'data-scope' => main_item, 'data-start_price' => start_price, 'data-id' => item['id'] %> <small><%=item['name']%></small>
    #         </div>
    #       <div class='col-4 text-right'>
    #           <small><%=number_to_currency(item['price'], unit: '+£') if item['price'].to_f > 0.0 %></small>
    #         </div>
    #       </div>
    #     <% end %>
    #  <% end if false %>



    def feature_match(feature, restaurant_features)
      restaurant_features.map{|s| s.key.to_sym}.include?(feature.to_sym)
    end
  
    def is_delivery?(restaurant)
      feature_match('delivery_service', restaurant.features)
    end
    def is_takeaway?(restaurant)
      feature_match('takeaway_service_enabled', restaurant.features)
    end
    def is_tableservice?(restaurant)
      feature_match('takeaway_to_table', restaurant.features)
    end
    

    def is_takeaway_or_delivery?(restaurant)
      ret = false
      del = is_delivery?(restaurant)
      take = is_takeaway?(restaurant)
      table = is_tableservice?(restaurant)
      ret = del if del
      ret = take if take
      ret = table if table
      ret
    end


end
