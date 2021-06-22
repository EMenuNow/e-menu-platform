class ConnectService < ApplicationController

  def initialize(restaurant)
    @restaurant = restaurant
    Stripe.api_key = @restaurant.stripe_sk_api_key
  end

  def create_account
    account = Stripe::Account.create({
      type: 'standard',
      country: @restaurant.currency.code == 'cad' ? 'CA' : 'GB',
      email: @restaurant.restaurant_user.email,
      default_currency: @restaurant.currency.code,
      metadata: {
        restaurant_name: @restaurant.name,
        restaurant_path: @restaurant.path,
        restaurant_telephone: @restaurant.telephone,
        restaurant_email: @restaurant.email,
      },
    })

    account_link = Stripe::AccountLink.create({
      account: account.id,
      refresh_url: (Rails.env.development? ? "http://localhost:3000/onboarding/restaurants/#{@restaurant.id}/connect" : Rails.application.routes.url_helpers.onboarding_restaurant_connect_url(@restaurant)),
      return_url: (Rails.env.development? ? "http://localhost:3000/onboarding/restaurants/#{@restaurant.id}/complete" : Rails.application.routes.url_helpers.onboarding_restaurant_complete_url(@restaurant)),
      type: 'account_onboarding',
      })
      
      {
        url: account_link.url,
        account_id: account.id
      }
    end
    
    def refresh_account(account_id)
      account_link = Stripe::AccountLink.create({
        account: account_id,
        refresh_url: (Rails.env.development? ? "http://localhost:3000/onboarding/restaurants/#{@restaurant.id}/connect" : Rails.application.routes.url_helpers.onboarding_restaurant_connect_url(@restaurant)),
        return_url: (Rails.env.development? ? "http://localhost:3000/onboarding/restaurants/#{@restaurant.id}/complete" : Rails.application.routes.url_helpers.onboarding_restaurant_complete_url(@restaurant)),
        type: 'account_onboarding',
      })
      
    url = account_link.url
  end

  def get_account
    account = Stripe::Account.retrieve(
      @restaurant.stripe_connected_account_id
    )
  end

end
