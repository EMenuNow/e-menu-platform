class AddGroupOrderFeatureToggle < ActiveRecord::Migration[6.0]
  def change
    Feature.create(key: 'group_orders', name: 'Group Orders')
  end
end
