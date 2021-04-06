

require 'rubygems'
require 'yaml'
require 'json'


namespace :printer do 
  desc "Check for failed prints and print"
    task :print_failed => :environment do
      Receipt.where(print_status: "Printer Error").each do |r|
        r.creation_print
      end
    end
  end
end
