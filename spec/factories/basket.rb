FactoryBot.define do
  factory :basket do
    contents { {"ids"=>[{"item"=>23, "note"=>nil, "uuid"=>"eecd1569-1ae2-4862-a97a-c2fb8f089d6c", "total"=>6.0, "menu_id"=>23, "optionals"=>[], "item_screen_type_key"=>nil, "item_screen_type_name"=>nil}, {"item"=>24, "note"=>nil, "uuid"=>"dd890abc-8af7-465c-b9ab-19903b4354c3", "total"=>5.5, "menu_id"=>24, "optionals"=>[], "item_screen_type_key"=>nil, "item_screen_type_name"=>nil}], "count"=>2, "restaurant"=>2} }
    key { "2-61e7cedc-a5a4-412d-92f3-0386201807ee" }
  end
end