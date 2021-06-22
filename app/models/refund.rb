# frozen_string_literal: true

class Refund < ApplicationRecord
    belongs_to :order

    after_create :email_receipt

    private

    def email_receipt
      receipt = order.receipts.first
      receipt.email_receipt
    end
end
