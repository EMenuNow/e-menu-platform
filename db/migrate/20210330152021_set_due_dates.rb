class SetDueDates < ActiveRecord::Migration[6.0]
  def change
    Order.where(due_date: nil).find_each do |o|
      r = o.restaurant
      d = r.opening_time.delay_time_minutes
      t = o.created_at
      c = o.collection_time
      if (c == "ASAP") or c.blank?
        dd = (t + d.minutes)
      else
        dd = (Time.parse("#{t.year}-#{t.month}-#{t.day} #{c}:00") - t.utc_offset)
      end
      o.update(due_date: dd)
    end
    
    Receipt.where(due_date: nil).find_each do |rc|
      r = rc.restaurant
      d = r.opening_time.delay_time_minutes
      t = rc.created_at
      c = rc.collection_time
      if (c == "ASAP") or c.blank?
        dd = (t + d.minutes)
      else
        dd = (Time.parse("#{t.year}-#{t.month}-#{t.day} #{c}:00") - t.utc_offset)
      end
      rc.update(due_date: dd)
    end
  end
end
