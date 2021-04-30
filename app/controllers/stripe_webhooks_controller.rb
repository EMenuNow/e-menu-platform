class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    EventFilterService.new(request)
  end
end
