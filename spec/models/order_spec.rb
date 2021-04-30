require 'rails_helper'

RSpec.describe Order, type: :model do
    describe "Initialize order" do
        let (:order) { FactoryBot.create(:order) }
        let (:receipt) { FactoryBot.create(:receipt) }

        it "Has a receipt" do
            expect(order.receipts.size).to eq(1)
        end
    end
end
