require 'rails_helper'

RSpec.describe DiscountCode, type: :model do
  
  describe "Basic discount code functionality" do
    let(:discount_code) { FactoryBot.create(:discount_code) }

    it "Creates discount code" do
      expect(discount_code.id).to eq(DiscountCode.all.first.id)
    end

    it "Has active? approach" do
      expect(discount_code.is_active?).to eq(true)
      expect(DiscountCode.is_active?.size).to eq(1)
    end

    it "Expiry date is returned correctly" do
      expect(discount_code.expiry_date).not_to eq("Never")
    end

    it "Limited number of discount types" do
      expect(DiscountCode.types.size).to eq(1)
    end
  end
  
  describe "Invalid discount code functionality" do
    let(:discount_code) { FactoryBot.build(:discount_code, :invalid_discount_code) }

    it "fails creation" do
      expect(discount_code.valid?).to eq(false)
      expect(discount_code.errors.size).to eq(3)
    end
  end
  
  describe "PercentageOffBasketDiscountCode unique code" do
    let(:discount_code) { FactoryBot.build(:percentage_off_discount_code) }

    it "fails creation" do
      expect(discount_code.valid?).to eq(true)
    end
  end
  
  describe "Invalid PercentageOffBasketDiscountCode unique code" do
    let(:discount_code) { FactoryBot.build(:percentage_off_discount_code, :invalid_percentage_off_discount_code) }

    it "fails creation" do
      expect(discount_code.valid?).to eq(false)
      expect(discount_code.errors.size).to eq(1)
    end
  end
end
