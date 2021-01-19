# frozen_string_literal: true

class Order < ApplicationRecord
    has_many :patron_orders, class_name: 'Patron::PatronOrder'
    has_many :patrons, through: :patron_orders
    belongs_to :restaurant
    has_many :receipts

    def first_or_create_receipt
      self.receipts.first_or_create(
        uuid: uuid,
        restaurant_id: self.restaurant_id,
        basket_total: self.basket_total,
        items: self.items,
        email: self.email,
        name: self.name,
        collection_time: self.collection_time,
        stripe_token: self.stripe_token || {},
        status: self&.stripe_data.try("payment_status", :[]) || {},
        is_ready: false,
        source: :takeaway, 
        telephone: self.telephone,
        address: self.address,
        delivery_or_collection: self.delivery_or_collection,
        delivery_fee: self.delivery_fee, 
        table_number: self.table_number,
        discount_code: self.discount_code
      )
    end

    private

 
end
