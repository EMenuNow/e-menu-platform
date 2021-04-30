FactoryBot.define do
  factory :feature do
    trait :images do
      id { 1 }
      name { "Images" }
      key { "images" }
    end
    trait :menu_in_sections do
      id { 8 }
      name { "Menu in Sections" }
      key { "menu_in_sections" }
    end
    trait :checkout do
      id { 13 }
      name { "Checkout" }
      key { "checkout" }
    end
  end
end