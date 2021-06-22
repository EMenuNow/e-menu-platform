class GroupOrderTaskWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'print'

  def perform(receipt_id)
    receipt = Receipt.find(receipt_id)
    PrinterService.new.print_grouped(receipt_id) if receipt.print_status != 'Printed' && receipt.print_status != 'No printer'
  end
end
