# frozen_string_literal: true

class EmenuMailer < ActionMailer::Base
  default from: 'noreply@emenunow.com'
  layout 'emenu_mailer'

  def welcome(restaurant_id, stripe_link)

    @restaurant = Restaurant.find(restaurant_id)
    @restaurant_user = @restaurant.restaurant_user
    @onboard = @restaurant_user.onboard
    @connect = stripe_link if stripe_link

    from = "EMenu Now <noreply@emenunow.com>"
    subject = "#{@restaurant.name}, welcome to EMenu Now"

    mail(to: @restaurant_user.email, from: from , subject: subject )
  end

end
