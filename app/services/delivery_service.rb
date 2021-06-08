class DeliveryService < ApplicationController

  def initialize(receipt_id)
    @receipt = Receipt.find(receipt_id)
    @restaurant = @receipt.restaurant

    @url = 'http://localhost:3001/receipt/create'

    @obj = {
      pickup: {
        name: @receipt.restaurant.name, # Required
        # companyName: @receipt.restaurant.name, #  Optional
        addressLine1: @receipt.restaurant.address, # Required - needs splitting out to line 1 and city
        # city: @receipt.restaurant.city, # Required - needs city creating
        postCode: @receipt.restaurant.postcode, # Required
        country: @receipt.restaurant.country, # Required - needs country creating
        phone: @receipt.restaurant.telephone, # Required
        # instructions: @receipt.restuarant.pickup_note, # Optional
        email: @receipt.restaurant.email, # Required
        # location: { # Optional
          # lat: @receipt.restaurant.lat,
          # long: @receipt.restaurant.long
        # }
      },
      dropoff: {
        name: @receipt.name, # Required
        # companyName: @receipt.name, # Optional
        addressLine1: @receipt.address, # Required
        # city: @receipt.city, # Required - needs city creating
        # postCode: @receipt.postcode, # Required - needs postcode creating
        # country: @receipt.country, # Required - needs country creating
        phone: @receipt.telephone, # Required
        # instructions: @receipt.delivery_note,  # Optional
        email: @receipt.email, # Required
        # location: { # Optional
          # lat: @receipt.lat,
          # long: @receipt.long
        # }
      },
      parcel: {
        handlingInstructions: [  # Required
          "contains_liquid"
        ],
        dimensions: { # Optional
          weightKg: 1,
          widthCm: 10,
          heightCm: 30,
          lenghtCm: 10
        },
        items: [ # Required
          {
            name: "Mineral Water"
          }
        ],
        reference: @receipt.restaurant.path + "_" + @receipt.id.to_s, # Required
        value: { # Required
          amount: @receipt.basket_total * 0.01,
          currency: @receipt.restaurant.currency_code
        }
      },
      schedule: { # Optional
        type: "urgent"
      },
      callbackUrl: "" # Optional
    }
  end

  def establish_order
    # Call delivery service API with receipt at checkout stage
    # Returns the delivery distance & estimated time
    responose = Faraday.post(@url, @obj, "Content-Type" => "application/json")
  end

  def create_order
    # Send data to delivery service API to create Orkestro order
    responose = Faraday.post(@url, @obj, "Content-Type" => "application/json")
  end

end
