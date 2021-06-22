class AddProcessingStatusToScreenItems < ActiveRecord::Migration[6.0]
  def change
    add_column :screen_items, :processing_status, :string, default: "pending"

    ScreenItem.where(ready: true).update_all(processing_status: 'ready')
    ScreenItem.where(ready: false).update_all(processing_status: 'accepted')
  end
end
