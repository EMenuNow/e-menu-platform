module Powerepos
  class GetOutlets < GetAuthService
    def initialize
      get_outlets
    end

    def get_local_outlets
      Restaurant.where.not(outletID: nil).each do |r|
        update_outlet_menu(r)
      end
    end

    def update_outlet_menu(restaurant)
      get_menus(restaurant)
    end

    private

    def get_outlets
      response = HTTParty.get("#{ENV['POWEREPOS_URL']}/remoteorders/activeoutlets/#{ENV['POWEREPOS_PROVIDER_ID']}",
        :headers => { 
          'Authorization' => "Bearer #{get_latest_token.access_token}",
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      )
      response["activeOrganisation"]["outletIDs"].each do |outletID|
        r = Restaurant.where(outletID: outletID)
        Restaurant.new(outletID: outletID).save(validate: false) if r.blank?
      end
    end

    def get_menus(restaurant)
      response = HTTParty.get("#{ENV['POWEREPOS_URL']}/remoteorders/menu/#{ENV['POWEREPOS_PROVIDER_ID']}/#{restaurant.outletID}",
        :headers => { 
          'Authorization' => "Bearer #{get_latest_token.access_token}",
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
      )
      response["menus"].each do |m|
        Menu.where(
          restaurant: restaurant,
          menuID: m.menuID
        ).first_or_create
      end
    end
  end
end
