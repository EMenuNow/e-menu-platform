class ChangeCoeliacToGlutenFree < ActiveRecord::Migration[6.0]
  def change
    coeliac = MenuItemCategorisation.find_by(name: 'coeliac')
    coeliac.update(name: 'gluten free') if coeliac
  end
end
