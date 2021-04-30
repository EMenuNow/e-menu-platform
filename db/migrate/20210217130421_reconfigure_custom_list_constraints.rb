class ReconfigureCustomListConstraints < ActiveRecord::Migration[6.0]
  def change
    add_column :custom_lists, :required_items, :boolean, default: false
    add_column :custom_lists, :limit_min, :integer
    add_column :custom_lists, :limit_count, :integer
    add_column :custom_lists, :limit_max, :integer

    CustomList.find_each do |l|
      if l.constraint == '*'
        l.required_items = false
      end
      
      if l.constraint == '1'
        l.required_items = true
        l.limit_count = 1
      end
      
      if l.constraint == '2'
        l.required_items = true
        l.limit_count = 2
      end
      
      if l.constraint == '3'
        l.required_items = true
        l.limit_count = 3
      end
      
      l.save
    end
  end
end
