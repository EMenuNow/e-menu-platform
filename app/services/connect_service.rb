class ConnectService < ApplicationController

  def initialize(restaurant)
    @restaurant = restaurant
    Stripe.api_key = Rails.env == 'production' ? @restaurant.stripe_chargeback_enabled ? ENV['STRIPE_PRO_API_KEY'] : ENV['STRIPE_API_KEY'] : @restaurant.stripe_chargeback_enabled ? 'sk_test_51IEEKiJyyGTIkLikMKhhmkTY4raz9JHFXp9qiQYwvJNRviHXdBqwpIez4Kva9vtbw6iMaT5qZML5vvGAK1n71i0c0013EXKJPf' : 'sk_test_hOj5WqYB26UV1v5uuqXsADSG'
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
