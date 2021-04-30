# frozen_string_literal: true

class PercentageOffBasketDiscountCode < DiscountCode
  validates :amount, numericality: { more_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def apply_discount_to_total(total)
    total * ((100 - self.amount)/100.0)
  end

  def description
    "#{self.amount}% discount"
  end

  def calculate_discount_from_basket_total(basket_total)
    (((basket_total / (100 - self.amount) * 100) - basket_total)/100)
  end
end
