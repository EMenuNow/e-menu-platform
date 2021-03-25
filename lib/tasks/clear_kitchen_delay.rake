require 'rubygems'

namespace :kitchen_delay do

  desc "Clear kitchen delay, unless restaurant open"
  task clear: :environment do

    OpeningTime.where.not(kitchen_delay_minutes: 0).find_each do |ot|
      r = ot.restaurant
      r.clear_kitchen_delay unless r.is_open
    end

  end

end