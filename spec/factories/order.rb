FactoryBot.define do
  factory :order do
    patrons { build_list :patron, 2 }
    restaurant { FactoryBot.build(:restaurant) }
    value { 100 }
    currency { "GBP" }
    
    uuid { SecureRandom.uuid }
    basket_total { 1000 }
    items { {"items"=>[{"item"=>"<i>STARTERS</i> - <strong>Caprese Salad </strong>", "note"=>nil, "uuid"=>"eecd1569-1ae2-4862-a97a-c2fb8f089d6c", "total"=>6.0, "menu_id"=>23, "optionals"=>[], "item_screen_type_key"=>nil, "item_screen_type_name"=>nil, "secondary_item_screen_type_key"=>nil, "secondary_item_screen_type_name"=>nil}, {"item"=>"<i>STARTERS</i> - <strong>COURGETTE FRITTI</strong>", "note"=>nil, "uuid"=>"dd890abc-8af7-465c-b9ab-19903b4354c3", "total"=>5.5, "menu_id"=>24, "optionals"=>[], "item_screen_type_key"=>nil, "item_screen_type_name"=>nil, "secondary_item_screen_type_key"=>nil, "secondary_item_screen_type_name"=>nil}]} }
    email { "" }
    name { "" }
    collection_time { "" }
    stripe_token { "pi_1Hr5wPELOyAFRPCSeZnwwKXs" }
    is_ready { false }
    telephone { "" }
    address { "" }
    delivery_or_collection { "" }
    delivery_fee { nil }
    table_number { "" }
    trait :paid do
      status { "paid" }
      stripe_data { {
        "id": "pi_1Hr5wPELOyAFRPCSeZnwwKXs",
        "object": "checkout.session",
        "allow_promotion_codes": nil,
        "amount_subtotal": nil,
        "amount_total": nil,
        "billing_address_collection": nil,
        "cancel_url": "https://example.com/cancel",
        "client_reference_id": nil,
        "currency": nil,
        "customer": nil,
        "customer_details": nil,
        "customer_email": nil,
        "livemode": "false",
        "locale": nil,
        "metadata": {
        },
        "mode": "payment",
        "payment_intent": "pi_00000000000000",
        "payment_method_types": [
          "card"
        ],
        "payment_status": "paid",
        "setup_intent": nil,
        "shipping": nil,
        "shipping_address_collection": nil,
        "submit_type": nil,
        "subscription": nil,
        "success_url": "https://example.com/success",
        "total_details": nil
      } }
    end
    trait :unpaid do
      status { "unpaid" }
      stripe_data { {
        "id": "pi_1Hr5wPELOyAFRPCSeZnwwKXs",
        "object": "checkout.session",
        "allow_promotion_codes": nil,
        "amount_subtotal": nil,
        "amount_total": nil,
        "billing_address_collection": nil,
        "cancel_url": "https://example.com/cancel",
        "client_reference_id": nil,
        "currency": nil,
        "customer": nil,
        "customer_details": nil,
        "customer_email": nil,
        "livemode": "false",
        "locale": nil,
        "metadata": {
        },
        "mode": "payment",
        "payment_intent": "pi_00000000000000",
        "payment_method_types": [
          "card"
        ],
        "payment_status": "unpaid",
        "setup_intent": nil,
        "shipping": nil,
        "shipping_address_collection": nil,
        "submit_type": nil,
        "subscription": nil,
        "success_url": "https://example.com/success",
        "total_details": nil
      } }
    end
    trait :refunded do
      status { "refunded" }
      stripe_data { {
        "id": "pi_1Hr5wPELOyAFRPCSeZnwwKXs",
        "object": "checkout.session",
        "allow_promotion_codes": nil,
        "amount_subtotal": nil,
        "amount_total": nil,
        "billing_address_collection": nil,
        "cancel_url": "https://example.com/cancel",
        "client_reference_id": nil,
        "currency": nil,
        "customer": nil,
        "customer_details": nil,
        "customer_email": nil,
        "livemode": "false",
        "locale": nil,
        "metadata": {
        },
        "mode": "payment",
        "payment_intent": "pi_00000000000000",
        "payment_method_types": [
          "card"
        ],
        "payment_status": "unpaid",
        "setup_intent": nil,
        "shipping": nil,
        "shipping_address_collection": nil,
        "submit_type": nil,
        "subscription": nil,
        "success_url": "https://example.com/success",
        "total_details": nil
      } }
    end
  end
end