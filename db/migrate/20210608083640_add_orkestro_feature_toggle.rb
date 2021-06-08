class AddOrkestroFeatureToggle < ActiveRecord::Migration[6.0]
  def change
    Feature.create(key: 'orkestro_delivery', name: 'Delivery with Orkestro')
  end
end
