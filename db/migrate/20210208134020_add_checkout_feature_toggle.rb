class AddCheckoutFeatureToggle < ActiveRecord::Migration[6.0]
  def change
    Feature.create(key: 'checkout', name: 'Checkout')

    reversible do |change|
      change.up do
        table_service = Feature.where(key: 'ordering').first
        table_service.update_attribute(:name, 'Table Ordering')
    
        table_takeaway = Feature.where(key: 'payment').first
        table_takeaway.update_attribute(:name, 'Table Payment')
      end
      
      change.down do
        table_service = Feature.where(key: 'ordering').first
        table_service.update_attribute(:name, 'Ordering')
    
        table_takeaway = Feature.where(key: 'payment').first
        table_takeaway.update_attribute(:name, 'Payment')
      end
    end
  end
end
