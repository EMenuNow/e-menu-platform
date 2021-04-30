class CreateCurrencies < ActiveRecord::Migration[6.0]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.string :symbol

      t.timestamps
    end

    Currency.create(name: "British Pound", code: 'gbp', symbol: '£' )
    Currency.create(name: "Canadian Dollar", code: 'cad', symbol: '$' )


  end
end
