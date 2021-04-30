class EventFilterService

  attr_reader :response

  def initialize(payload)
    # authorization logic (optional to-do)
    # @signature = request.headers['Stripe-Signature']
    # return Unauthorized unless valid_signature

    @payload = payload
    @response = respond
  end

  private

  def respond
    case @payload[:type]
    when "checkout.session.completed"
      CheckoutSessionCompletedService.new(@payload)
    end
  end

  def valid_signature
    [
    "whsec_ZIsIdoyLZ96TuCNrioMPgUugkHRnj2DD",
    "whsec_XqObEsFNKsoIO9jiEuO3BSaYXAw9Cp6U",
    "whsec_EZ7G0NPH2Ce9V2ZhSJzhqMonGdwV7wy1",
    "whsec_H8LLRfRMfHrQxDxG8VfTsvdyrYxrhIam"
    ].include?(@signature)
  end
end