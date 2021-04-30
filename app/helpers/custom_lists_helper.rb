module CustomListsHelper

	def constraint_to_human(constraint)
		case constraint
			when '*'
				t('menu.options_to_human.zero_more')
			when '1'
				t('menu.options_to_human.one')
			when '2'
				t('menu.options_to_human.two')
			when '3'
				t('menu.options_to_human.three')
		end			
	end

  def cl_message_to_human(custom_list)
    if custom_list.required_items # required items
      if custom_list.limit_min && custom_list.limit_max # between min and max
        "Please choose at least #{pluralize(custom_list.limit_min, 'option')}, but no more than #{custom_list.limit_max}"
      elsif custom_list.limit_count # exact amount
        "Please choose #{pluralize(custom_list.limit_count, 'option')}"
      elsif custom_list.limit_min && !custom_list.limit_max # at least minimum
        "Please choose at least #{pluralize(custom_list.limit_min, 'option')}"
      end
    else
      if !custom_list.limit_min && custom_list.limit_max # at least minimum
        "Please choose up to #{pluralize(custom_list.limit_max, 'option')}"
      else
        "Optional"
      end
    end
  end

end
