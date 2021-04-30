# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@emenunow.com'
  layout 'mailer'

  def receipt(receipt_id)
    
    @receipt = Receipt.find(receipt_id)
    @restaurant = @receipt.restaurant

    from = "#{@restaurant.name} <noreply@emenunow.com>"

    mail(to: @receipt.email, from: from , subject: @restaurant.name)
  end

end
