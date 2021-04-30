require 'rails_helper'

RSpec.describe StripeWebhooksController, type: :request do
  include_examples "Stripe webhooks"

  describe "POST index" do
    let(:order) { FactoryBot.create(:order, :unpaid) }

    it "checkout.session.completed" do
      order
      post "/stripe-webhooks", :params => payload_paid
      new_order = Order.where("stripe_data ->> 'payment_intent' = ?", order.stripe_data['payment_intent']).first
      expect(new_order.status).to eq("paid")
      expect(new_order.stripe_data).to eq(payload_paid[:data][:object].as_json)
    end
  end

end
