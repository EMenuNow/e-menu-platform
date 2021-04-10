

require 'rubygems'
require 'yaml'
require 'json'


namespace :printer do 
  task :print_failed => :environment do
    states = ["Printer Error", nil, "Sent to printer"]
    rs = []
    Receipt.where(print_status: states).each do |r|
      rs += r.find_grouped_receipts
    end
    rs.flatten.uniq.each do |g|
      is_new_group = rs.size > 1 && rs.first.created_at > 5.minutes.ago
      if rs.size == 1 || (!is_new_group && states.include?(g.print_status))
        g.creation_print
        g.item_breakdown
      end
    end
  end
end
