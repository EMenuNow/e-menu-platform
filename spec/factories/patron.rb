FactoryBot.define do
  factory :patron do
    email { "test#{rand(1..1000)}@test.com" }
    has_no_password { true }
    
    trait :sign_up_redirect do
      redirect_after_signup_to { "/order/lulus" }
    end
    password { "testtest" }
    
    trait :with_password do
      password { "testtest" }
      has_no_password { false }
    end
    
    trait :invalid_email do
      email { "testtest.com" }
    end

    trait :with_orders do
      orders { build_list :order, 3 }
    end
  end
end
