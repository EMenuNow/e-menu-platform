

require 'rubygems'
require 'yaml'
require 'json'


namespace :reporting do
 
 
 
 
 

 
  desc "Daily Report to run it rails reporting:daily\['2020-10-01'\]"
    task :all, [:date] => [:environment] do |t, args|

      from = Date.yesterday - 30.days
      to = Date.yesterday
      (from .. to).each do |date|
        
        puts "invoking with #{date}"
        # Rake::Task["reporting:daily"].invoke("#{date}")
        Rake::Task['reporting:daily'].execute({date: date})
        puts "Done invoking "
      end

    end
  
 
 
  desc "Daily Report to run it rails reporting:daily\['2020-10-01'\]"
    task :daily, [:date] => [:environment] do |t, args|
     

      puts args
      date = args[:date]

    # Daily Reporting
    date = Date.today if date.blank?


    puts "Processing Date: #{date}"
    Restaurant.all.each do |restaurant|
      all_receipts = []
      items = []
      # binding.pry
      Receipt.where(restaurant_id: restaurant.id).where('created_at::date = ?', date).each do |receipt|
        all_receipts << receipt.zreport.except(:items)
        # binding.pry
        items.concat(receipt.zreport[:items])

      end
      dr = DailyReporting.find_or_create_by(
        restaurant_id: restaurant.id,
        date: date 
      ) 
      total = all_receipts.map{|a| a[:basket_total]}.inject(:+) || 0
      dr.total = total
      count = all_receipts.map{|a| a[:item_count]}.inject(:+) || 0
      dr.items_count = count  
      dr.data = items
      dr.save

    end


# daily_reporting restaurant:references data:jsonb date:date total:integer items_count:integer

  end
end
