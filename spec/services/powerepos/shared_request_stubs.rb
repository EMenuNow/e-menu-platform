RSpec.shared_context "shared request stubs", :shared_context => :metadata do
  before(:each) do
    epos_auth_request = {
      grant_type: 'client_credentials',
      client_id: ENV['POWEREPOS_CLIENT_ID'],
      client_secret: ENV['POWEREPOS_CLIENT_SECRET'],
      org_id: ENV['POWEREPOS_ORG_ID'],
      scope: 'ros offline_access'
    }
    epos_auth_response = {
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
      }, body: epos_auth_request)
      .to_return(status: 200, body: epos_auth_response.to_json)
  end
end

RSpec.configure do |rspec|
  rspec.include_context "shared request stubs", :include_shared => true
end