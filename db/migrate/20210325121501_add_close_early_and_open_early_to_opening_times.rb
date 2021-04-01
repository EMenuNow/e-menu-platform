class AddCloseEarlyAndOpenEarlyToOpeningTimes < ActiveRecord::Migration[6.0]
  def change
    add_column :opening_times, :open_early, :boolean, default: false
    add_column :opening_times, :close_early, :boolean, default: false
  end
end
