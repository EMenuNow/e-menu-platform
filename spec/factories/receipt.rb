FactoryBot.define do
  factory :receipt do
    order { FactoryBot.create(:order) }
    restaurant { FactoryBot.create(:restaurant) }
    uuid { SecureRandom.uuid }
    basket_total { 0 }
    items { {"items"=>[{"item"=>"<i>STARTERS</i> - <strong>Caprese Salad </strong>", "note"=>nil, "uuid"=>"eecd1569-1ae2-4862-a97a-c2fb8f089d6c", "total"=>6.0, "menu_id"=>23, "optionals"=>[], "item_screen_type_key"=>nil, "item_screen_type_name"=>nil, "secondary_item_screen_type_key"=>nil, "secondary_item_screen_type_name"=>nil}, {"item"=>"<i>STARTERS</i> - <strong>COURGETTE FRITTI</strong>", "note"=>nil, "uuid"=>"dd890abc-8af7-465c-b9ab-19903b4354c3", "total"=>5.5, "menu_id"=>24, "optionals"=>[], "item_screen_type_key"=>nil, "item_screen_type_name"=>nil, "secondary_item_screen_type_key"=>nil, "secondary_item_screen_type_name"=>nil}]} }
    email { "" }
    name { "" }
    collection_time { "" }
    stripe_token { "pi_1Hr5wPELOyAFRPCSeZnwwKXs" }
    status { "{\"id\"=>\"pi_1Hr5wPELOyAFRPCSeZnwwKXs\", \"object\"=>\"payment_intent\", \"allowed_source_types\"=>[\"card\"], \"amount\"=>1150, \"canceled_at\"=>nil, \"cancellation_reason\"=>nil, \"capture_method\"=>\"automatic\", \"client_secret\"=>\"pi_1Hr5wPELOyAFRPCSeZnwwKXs_secret_EvXd1mKWlIN6g496dAiSzl0qf\", \"confirmation_method\"=>\"automatic\", \"created\"=>1606241317, \"currency\"=>\"gbp\", \"description\"=>\" charge\", \"last_payment_error\"=>nil, \"livemode\"=>false, \"next_action\"=>nil, \"next_source_action\"=>nil, \"payment_method\"=>\"pm_1Hr5wUELOyAFRPCSzfW8Hrph\", \"payment_method_types\"=>[\"card\"], \"receipt_email\"=>nil, \"setup_future_usage\"=>nil, \"shipping\"=>nil, \"source\"=>nil, \"status\"=>\"succeeded\"}" }
    is_ready { false }
    source { :takeaway } 
    telephone { "" }
    address { "" }
    delivery_or_collection { "" }
    delivery_fee { nil }
    table_number { "" }
  end
end