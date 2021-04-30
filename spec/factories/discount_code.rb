FactoryBot.define do
  factory :discount_code do
    code { "123" }
    restaurant { FactoryBot.build(:restaurant) }
    amount { 21 }
    type { "PercentageOffBasketDiscountCode" }
    max_uses { 10 }
    used_times { 0 }
    expires_on { 7.days.from_now }
    single_use_per_user { false }
    
    trait :invalid_discount_code do
      code { "12" }
      restaurant {  }
      amount { 2112 }
      type { "Percentage" }
    end
  end

  factory :percentage_off_discount_code, class: "PercentageOffBasketDiscountCode" do
    code { "123" }
    restaurant { FactoryBot.build(:restaurant) }
    amount { 21 }
    type { "PercentageOffBasketDiscountCode" }

    trait :invalid_percentage_off_discount_code do
      amount { 2112 }
    end
  end
end
