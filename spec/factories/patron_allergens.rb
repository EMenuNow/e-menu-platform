FactoryBot.define do
  factory :patron_allergens do
    patron { FactoryBot.build(:patron) }
    gluten { true }
    celery { true }
    tree_nuts { true }
    fish { true }
    soy { true }
    sesame { true }
    peanuts { true }
    crustaceans { true }
    eggs { true }
    molluscs { true }
    milk { true }
    mustard { true }
    sulphur_dioxide_sulphates { true }
    lupin { true }

  end
end
