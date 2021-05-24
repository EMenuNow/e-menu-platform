class AddCoeliacDietary < ActiveRecord::Migration[6.0]
  def change
    MenuItemCategorisation.create(name: 'coeliac', icon: 'eicon eicon-circle-coeliac', type: 'Dietary')
  end
end
