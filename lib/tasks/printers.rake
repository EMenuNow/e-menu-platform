

require 'rubygems'
require 'yaml'
require 'json'


namespace :printer do 
  task :print_failed => :environment do
    print
  end
  task :print_failed_2 => :environment do
    print
  end

  private

  def print
    states = ["Printer Error", "Sent to printer", nil]
    Receipt.group_by_time(Receipt.where(print_status: states)).reverse.each do |k, v|
      if !v.last.is_recent_group_order? && states.include?(v.last.print_status) && (v.last.created_at > 30.minutes.ago or v.last.due_date.future?)
        v.last.creation_print
        v.last.item_breakdown
        v.each{|x|x.update_attributes(print_status: "Printed")} if Rails.env.development?
        v.last.broadcast(message: "New") if v.last.group_order
        v.last.broadcast_items(message: "New") if v.last.group_order
      end
    end
  end
end
