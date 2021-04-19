require "rails_helper"

RSpec.describe Powerepos::GetAuthService do

  describe 'with a successful call' do
    before(:each) do
      epos_request = {
        grant_type: 'client_credentials',
        client_id: ENV['POWEREPOS_CLIENT_ID'],
        client_secret: ENV['POWEREPOS_CLIENT_SECRET'],
        org_id: ENV['POWEREPOS_ORG_ID'],
        scope: 'ros offline_access'
      }
      epos_response = {
        token_type: "Bearer",
        access_token: "test_ac",
        expires_in: 28800,
        refresh_token: "test_rt"
      }
      stub_request(:post, "https://auth.powerepos.cloud/authorisation/token/")
        .with(headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }, body: epos_request)
        .to_return(status: 200, body: epos_response.to_json)
    end
    let(:epos_response) { Powerepos::GetAuthService.new.get_latest_token.first }

    context 'Gets latest token' do

      it 'gets latest token' do
        expect(epos_response.attributes).to include("access_token")
        expect(epos_response.attributes).to include("expires_in")
        expect(epos_response.attributes).to include("refresh_token")
      end
    end
  end
end
