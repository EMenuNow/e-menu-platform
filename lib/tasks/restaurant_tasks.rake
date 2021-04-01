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

namespace :opening_times do

  desc "Clears open early attribute, unless restaurant is closed"
  task clear_open_early: :environment do

    OpeningTime.where(open_early: true).find_each do |ot|
      r = ot.restaurant
      r.clear_open_early if r.is_open
    end
  end

  desc "Clears close early attribute, unless restaurant is open"
  task clear_close_early: :environment do

    OpeningTime.where(close_early: true).find_each do |ot|
      r = ot.restaurant
      r.clear_close_early unless r.is_open
    end

  end

end