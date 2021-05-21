class DailyReporting < ApplicationRecord
  belongs_to :restaurant

  def get_vat_total
    totals = []
    self.data.map{|a| a['menu_parent_name'] }.uniq.each do |menu_id|
      values = self.data.select{|a| a['menu_parent_name'] == menu_id } 
      totals.push(values.map{|x| x['total'] * (x['tax_rate'].to_f/100.0)}.sum)
    end
    totals.sum
  end

end
