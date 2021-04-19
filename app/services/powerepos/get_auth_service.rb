module Powerepos
  class GetAuthService
    include HTTParty
    base_uri 'https://auth.powerepos.cloud/'

    def initialize
      get_token
    end

    def get_latest_token
      Powerepos::PowereposAuth.where("updated_at > ?", 7.hours.ago)
    end

    private

    def get_token
      power_epos_auth = get_latest_token.first_or_create do |auth|
        response = HTTParty.post("https://auth.powerepos.cloud/authorisation/token/", 
          :body =>  { 
            :grant_type => 'client_credentials',
            :client_id => ENV['POWEREPOS_CLIENT_ID'],
            :client_secret => ENV['POWEREPOS_CLIENT_SECRET'],
            :org_id => ENV['POWEREPOS_ORG_ID'],
            :scope => 'ros offline_access'
          },
          :headers => { 'Content-Type' => 'application/x-www-form-urlencoded' }
        )
        auth.token_type = response['token_type']
        auth.access_token = response['access_token']
        auth.refresh_token = response['refresh_token']
        auth.expires_in = response['expires_in']
      end
    end
  end
end
