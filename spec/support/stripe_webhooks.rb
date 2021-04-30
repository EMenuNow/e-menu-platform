RSpec.shared_examples "Stripe webhooks" do
  let(:payload_paid) do
    {
      "created": 1326853478,
      "livemode": false,
      "id": "evt_00000000000000",
      "type": "checkout.session.completed",
      "object": "event",
      "request": nil,
      "pending_webhooks": 1,
      "api_version": "2018-11-08",
      "data": {
        "object": {
          "id": "pi_1Hr5wPELOyAFRPCSeZnwwKXs",
          "object": "checkout.session",
          "allow_promotion_codes": nil,
          "amount_subtotal": nil,
          "amount_total": nil,
          "billing_address_collection": nil,
          "cancel_url": "https://example.com/cancel",
          "client_reference_id": nil,
          "currency": nil,
          "customer": nil,
          "customer_details": nil,
          "customer_email": nil,
          "livemode": "false",
          "locale": nil,
          "mode": "payment",
          "payment_intent": "pi_00000000000000",
          "payment_method_types": [
            "card"
          ],
          "payment_status": "paid",
          "setup_intent": nil,
          "shipping": nil,
          "shipping_address_collection": nil,
          "submit_type": nil,
          "subscription": nil,
          "success_url": "https://example.com/success",
          "total_details": nil
        }
      }
    }
  end
  let(:payload_unpaid) do
    {
      "created": 1326853478,
      "livemode": false,
      "id": "evt_00000000000000",
      "type": "checkout.session.completed",
      "object": "event",
      "request": nil,
      "pending_webhooks": 1,
      "api_version": "2018-11-08",
      "data": {
        "object": {
          "id": "pi_1Hr5wPELOyAFRPCSeZnwwKXs",
          "object": "checkout.session",
          "allow_promotion_codes": nil,
          "amount_subtotal": nil,
          "amount_total": nil,
          "billing_address_collection": nil,
          "cancel_url": "https://example.com/cancel",
          "client_reference_id": nil,
          "currency": nil,
          "customer": nil,
          "customer_details": nil,
          "customer_email": nil,
          "livemode": "false",
          "locale": nil,
          "mode": "payment",
          "payment_intent": "pi_00000000000000",
          "payment_method_types": [
            "card"
          ],
          "payment_status": "unpaid",
          "setup_intent": nil,
          "shipping": nil,
          "shipping_address_collection": nil,
          "submit_type": nil,
          "subscription": nil,
          "success_url": "https://example.com/success",
          "total_details": nil
        }
      }
    }
  end
  let(:payload_refunded) do
    {
      "created": 1326853478,
      "livemode": false,
      "id": "evt_00000000000000",
      "type": "checkout.session.completed",
      "object": "event",
      "request": nil,
      "pending_webhooks": 1,
      "api_version": "2018-11-08",
      "data": {
        "object": {
          "id": "pi_1Hr5wPELOyAFRPCSeZnwwKXs",
          "object": "checkout.session",
          "allow_promotion_codes": nil,
          "amount_subtotal": nil,
          "amount_total": nil,
          "billing_address_collection": nil,
          "cancel_url": "https://example.com/cancel",
          "client_reference_id": nil,
          "currency": nil,
          "customer": nil,
          "customer_details": nil,
          "customer_email": nil,
          "livemode": "false",
          "locale": nil,
          "mode": "payment",
          "payment_intent": "pi_00000000000000",
          "payment_method_types": [
            "card"
          ],
          "payment_status": "unpaid",
          "setup_intent": nil,
          "shipping": nil,
          "shipping_address_collection": nil,
          "submit_type": nil,
          "subscription": nil,
          "success_url": "https://example.com/success",
          "total_details": nil
        }
      }
    }
  end
end