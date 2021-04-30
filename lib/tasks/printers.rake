require 'rubygems'
require 'yaml'
require 'json'

namespace :printer do 
  task :print_failed => :environment do
    PrinterService.new.print_failed
  end

end
