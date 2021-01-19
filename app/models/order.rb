# frozen_string_literal: true

class Order < ApplicationRecord
    has_many :patron_orders, class_name: 'Patron::PatronOrder'
    has_many :patrons, through: :patron_orders
    belongs_to :restaurant
    has_many :receipts

    after_create :create_receipt

    attr_accessor :uuid, :basket_total, :items, :email, :name, :collection_time, :stripe_token, :status, :is_ready, :source, :telephone, :address, :delivery_or_collection, :delivery_fee, :table_number, :stripe_data, :stripe_token, :discount_code

    private

    def create_receipt
      self.receipts.create(
        uuid: uuid,
        restaurant_id: self.restaurant_id,
        basket_total: self.basket_total,
        items: self.items,
        email: self.email,
        name: self.name,
        collection_time: self.collection_time,
        stripe_token: self.stripe_token || {},
        status: self.stripe_data || {},
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
 
end
