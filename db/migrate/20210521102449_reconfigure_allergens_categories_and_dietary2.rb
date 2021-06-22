class ReconfigureAllergensCategoriesAndDietary2 < ActiveRecord::Migration[6.0]
  def change


    reversible do |change|
      change.up do

        MenuItemCategorisation.update_all(type: 'Category')
        MenuItemCategorisationsMenu.update_all(category: true)

        [
          { 'name' => 'cereal', 'icon' => 'eicon eicon-circle-cereal' },
          { 'name' => 'gluten', 'icon' => 'eicon eicon-circle-gluten' },
          { 'name' => 'milk', 'icon' => 'eicon eicon-circle-milk' },
          { 'name' => 'eggs', 'icon' => 'eicon eicon-circle-eggs' },
          { 'name' => 'peanuts', 'icon' => 'eicon eicon-circle-peanuts' },
          { 'name' => 'tree_nuts', 'icon' => 'eicon eicon-circle-nuts' },
          { 'name' => 'crustaceans', 'icon' => 'eicon eicon-circle-crustaceans' },
          { 'name' => 'mustard', 'icon' => 'eicon eicon-circle-mustard' },
          { 'name' => 'fish', 'icon' => 'eicon eicon-circle-fish' },
          { 'name' => 'lupin', 'icon' => 'eicon eicon-circle-lupin' },
          { 'name' => 'sesame', 'icon' => 'eicon eicon-circle-sesame' },
          { 'name' => 'celery', 'icon' => 'eicon eicon-circle-celery' },
          { 'name' => 'soya', 'icon' => 'eicon eicon-circle-soya' },
          { 'name' => 'molluscs', 'icon' => 'eicon eicon-circle-molluscs' },
          { 'name' => 'sulphur_dioxide_and_sulphates', 'icon' => 'eicon eicon-circle-so2' }
        ].each do |obj|
          MenuItemCategorisation.create(
            name: obj['name'], icon: obj['icon'], type: 'Allergen'
          )
        end

        [
          { 'name' => 'vegetarian', 'icon' => 'eicon eicon-circle-vegetarian' },
          { 'name' => 'vegan', 'icon' => 'eicon eicon-circle-vegan' },
          { 'name' => 'kosher', 'icon' => 'eicon eicon-circle-kosher' },
          { 'name' => 'halal', 'icon' => 'eicon eicon-circle-halal' },
          # { 'name' => 'coeliac', 'icon' => 'eicon eicon-circle-coeliac' }
        ].each do |obj|
          MenuItemCategorisation.where('lower(name) = ?', obj['name'].downcase)
          .first_or_create.update(
            name: obj['name'], icon: obj['icon'], type: 'Dietary'
          )
        end

        

        vegan = MenuItemCategorisation.where('lower(name) = ?', 'vegan'.downcase)
        veggie = MenuItemCategorisation.where('lower(name) = ?', 'vegetarian'.downcase)
        kosher = MenuItemCategorisation.where('lower(name) = ?', 'kosher'.downcase)
        halal = MenuItemCategorisation.where('lower(name) = ?', 'halal'.downcase)

        MenuItemCategorisationsMenu.where(menu_item_categorisation: vegan).update_all(category: nil, dietary: true)
        MenuItemCategorisationsMenu.where(menu_item_categorisation: veggie).update_all(category: nil, dietary: true)
        MenuItemCategorisationsMenu.where(menu_item_categorisation: kosher).update_all(category: nil, dietary: true)
        MenuItemCategorisationsMenu.where(menu_item_categorisation: halal).update_all(category: nil, dietary: true)

      end

      change.down do

        MenuItemCategorisation.where(type: 'Allergen').delete_all

        MenuItemCategorisation.find_by(name: 'coeliac').destroy

        [
          { 'name' => 'vegetarian', 'icon' => 'fi flaticon-keyboard-key-v' },
          { 'name' => 'vegan', 'icon' => 'fi flaticon-food' },
          { 'name' => 'kosher', 'icon' => 'fi flaticon-keyboard-key-k' },
          { 'name' => 'halal', 'icon' => 'fi flaticon-key-h-of-a-keyboard' }
        ].each do |obj|
          MenuItemCategorisation.where('lower(name) = ?', obj['name'].downcase)
          .first_or_create.update(
            name: obj['name'].humanize, icon: obj['icon']
          )
        end

        MenuItemCategorisation.all.update_all(type: 'Allergen')

      end
    end
  end
end
