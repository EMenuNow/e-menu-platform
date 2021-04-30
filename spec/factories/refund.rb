FactoryBot.define do
  factory :refund do
    stripe_data {{
      "id": "re_1IQwskJyyGTIkLikV9U49IJu",
      "object": "refund",
      "amount": 1000,
      "balance_transaction": "txn_1IQwskJyyGTIkLikihbwTBZ7",
      "charge": "ch_1IQATXJyyGTIkLikPi8m2I4n",
      "created": 1614786302,
      "currency": "gbp",
      "metadata": {},
      "payment_intent": "pi_00000000000000",
      "reason": null,
      "receipt_number": null,
      "source_transfer_reversal": null,
      "status": "succeeded",
      "transfer_reversal": null
    }}
  end
end