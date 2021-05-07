require "rails_helper"
require "./spec/services/powerepos/shared_request_stubs.rb"

RSpec.describe Powerepos::GetAuthService do

  describe 'with a successful call' do
    include_context "shared request stubs"

    let(:epos_response) { Powerepos::GetAuthService.new.get_latest_token }

    context 'Gets latest token' do

      it 'gets latest token' do
        expect(epos_response.attributes).to include("access_token")
        expect(epos_response.attributes).to include("expires_in")
        expect(epos_response.attributes).to include("refresh_token")
      end
    end
  end
end
