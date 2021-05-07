require "rails_helper"
require "./spec/services/powerepos/shared_request_stubs.rb"

RSpec.describe Powerepos::GetOutlets do

  describe 'with a successful call' do
    include_context "shared request stubs"

    before(:each) do
      epos_outlets_response = {
        "providerID": "Bearer",
        "activeOrganisation": { 
          "kapow": "callId",
          "organisationCode": "",
          "outletIDs": [
            "outLet1",
            "outLet2"
          ]
        }
      }
      stub_request(:get, "#{ENV['POWEREPOS_URL']}/remoteorders/activeoutlets/#{ENV['POWEREPOS_PROVIDER_ID']}")
        .with(headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        })
        .to_return(status: 200, body: epos_outlets_response.to_json)
    end
    let(:epos_outlets_response) { Powerepos::GetOutlets.new }

    context 'Gets latest token' do
      it 'gets latest token' do
        expect(epos_outlets_response.get_local_outlets.size).to eq(1)
      end
    end
  end
end
