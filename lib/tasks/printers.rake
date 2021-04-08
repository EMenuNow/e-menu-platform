

require 'rubygems'
require 'yaml'
require 'json'


namespace :printer do 
  task :print_failed => :environment do
    states = ["Printer Error", nil]
    Receipt.where(print_status: states).each do |r|
      r.find_grouped_receipts.each do |r|
        r.creation_print if states.include?(r.print_status)
      end
    end
  end
end
