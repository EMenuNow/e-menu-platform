class AddAutoReadyFeatureToggle < ActiveRecord::Migration[6.1]
  def change
    Feature.create(key: 'auto_ready', name: 'Auto Ready')
  end
end
