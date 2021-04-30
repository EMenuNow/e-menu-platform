require 'rails_helper'

RSpec.describe EventFilterService do
  include_examples "Stripe webhooks"
  describe "Modify order history unpaid to paid" do
    let(:order) { FactoryBot.create(:order, :unpaid) }
    let(:event) { EventFilterService.new(payload_paid) }

    it "completes correctly" do
      order
      event
      new_order = Order.where("stripe_data ->> 'payment_intent' = ?", order.stripe_data['payment_intent']).first
      expect(new_order.status).to eq("paid")
      expect(new_order.stripe_data).to eq(payload_paid[:data][:object].as_json)
    end
  end

  describe "Modify order history paid to unpaid" do
    let(:order) { FactoryBot.create(:order, :paid) }
    let(:event) { EventFilterService.new(payload_unpaid) }

    it "completes correctly" do
      order
      event
      new_order = Order.where("stripe_data ->> 'payment_intent' = ?", order.stripe_data['payment_intent']).first
      expect(new_order.status).to eq("unpaid")
      expect(new_order.stripe_data).to eq(payload_unpaid[:data][:object].as_json)
    end
  end
end
