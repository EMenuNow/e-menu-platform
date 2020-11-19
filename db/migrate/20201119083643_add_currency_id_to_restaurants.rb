class AddCurrencyIdToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_reference :restaurants, :currency, null: true, foreign_key: true

  
    cid = Currency.find_by(code: 'gbp').id
    Restaurant.update(currency_id: cid)

  end
end
