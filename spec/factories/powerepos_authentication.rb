FactoryBot.define do
  factory :powerepos_authentication do
		auth_token { "token" }
		refresh_token { "refresh_token" }
    expires_in { 28800 }
    created_at { 10.minutes.ago }
  end
end