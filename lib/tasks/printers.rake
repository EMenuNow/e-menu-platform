

require 'rubygems'
require 'yaml'
require 'json'


namespace :printer do 
  task :print_failed => :environment do
    states = ["Printer Error", "Sent to printer", nil]
    Receipt.group_by_time(Receipt.where(print_status: states)).reverse.each do |k, v|
      is_new_group = v.size > 1 && v.last.created_at > 5.minutes.ago
      if (v.size == 1 || (!is_new_group && states.include?(v.first.print_status))) && v.first.created_at > 30.minutes.ago
        v.first.creation_print
        v.first.item_breakdown
      end
    end
  end
end
