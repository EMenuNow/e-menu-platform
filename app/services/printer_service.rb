class PrinterService

  def initialize

  end

  def print_failed
    states = ["Printer Error", "Sent to printer", nil]
    Receipt.group_by_time(Receipt.where(print_status: states)).reverse.each do |k, v|
      if !v.last.is_recent_group_order? && states.include?(v.last.print_status) && (v.last.created_at > 30.minutes.ago or v.last.due_date.future?)
        v.last.creation_print
        v.last.item_breakdown
        v.each{|x|x.update(print_status: "Printed")} if Rails.env.development?
        v.last.broadcast(message: "New") if v.last.group_order
        v.last.broadcast_items(message: "New") if v.last.group_order
      end
    end
  end

  def print_grouped(receipt_id)
    receipt = Receipt.find(receipt_id)
    receipts = receipt.find_grouped_receipts    
    receipt.creation_print
    receipt.item_breakdown
    receipts.each{|x|x.update(print_status: "Printed")} if Rails.env.development?
    receipt.broadcast(message: "New") if receipt.group_order
    receipt.broadcast_items(message: "New") if receipt.group_order
  end

end