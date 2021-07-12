# frozen_string_literal: true

class Order < ApplicationRecord
    has_many :patron_orders, class_name: 'Patron::PatronOrder'
    has_many :patrons, through: :patron_orders
    belongs_to :restaurant
    belongs_to :discount_code, optional: true
    has_many :receipts
    validates_length_of :receipts, maximum: 1
    has_many :refunds

    def first_or_create_receipt
      r = self.receipts.where(uuid: uuid).first_or_initialize do |receipt|
        auto_ready = self.restaurant.features.map{|s| s.key.to_sym}.include?('auto_ready'.to_sym)

        receipt.restaurant_id = self.restaurant_id
        receipt.basket_total = self.basket_total
        receipt.items = self.items
        receipt.email = self.email
        receipt.name = self.name
        receipt.collection_time = self.collection_time
        receipt.due_date = self.due_date
        receipt.stripe_token = self.stripe_token || {}
        receipt.status = self&.stripe_data.try("payment_status", :[]) || {}
        receipt.is_ready = auto_ready ? true : false
        receipt.source = :takeaway 
        receipt.telephone = self.telephone
        receipt.address = self.address
        receipt.delivery_or_collection = self.delivery_or_collection
        receipt.delivery_fee = self.delivery_fee 
        receipt.table_number = self.table_number
        receipt.discount_code = self.discount_code
        receipt.application_fee_amount = self.application_fee_amount
        receipt.stripe_processing_fee = self.stripe_processing_fee
        receipt.emenu_commission = self.emenu_commission
        receipt.chargeback_fee = self.chargeback_fee
        receipt.chargeback_enabled = self.chargeback_enabled
        receipt.emenu_vat_charge = self.emenu_vat_charge
        receipt.group_order = self.group_order
        receipt.tax_rates = self.tax_rates
        receipt.processing_status = auto_ready ? "ready" : "accepted" # temporary until pending payments is built
      end
      r.save
      r
    end

    private

 
end
