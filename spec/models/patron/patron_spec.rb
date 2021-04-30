require 'rails_helper'

RSpec.describe Patron, type: :model do
  describe "Get order history" do
    
    let(:patron) { FactoryBot.build :patron, :with_orders }

    it "#get_order_history" do
      expect(patron.get_order_history.size).to eq(3)
    end
  end
end
