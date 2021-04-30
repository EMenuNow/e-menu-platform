class RenameServiceNames < ActiveRecord::Migration[6.0]
  def up
    table_service = Feature.where(key: 'table_service_enabled').first
    table_service.update_attribute(:name, 'Pay-at-end Table Service')

    table_takeaway = Feature.where(key: 'takeaway_to_table').first
    table_takeaway.update_attribute(:name, 'Pre-pay Table Service')
  end
  def down
    table_service = Feature.where(key: 'table_service_enabled').first
    table_service.update_attribute(:name, 'Table service enabled')

    table_takeaway = Feature.where(key: 'takeaway_to_table').first
    table_takeaway.update_attribute(:name, 'Takeaway to table')
  end
end
