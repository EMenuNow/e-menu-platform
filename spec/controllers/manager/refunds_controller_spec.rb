require 'rails_helper'

RSpec.describe Manager::RefundsController, type: :controller do

  describe "POST #create" do
    order = FactoryBot.create(:order, :paid)
    login_manager(restaurant_user: order.restaurant.restaurant_user)
    before { allow(controller).to receive(:authenticate_manager_restaurant_user!).and_return(true) }
    
    let (:order) { order }
    let (:refund) { FactoryBot.create(:refund) }

    before { StripeMock.start }
    after { StripeMock.stop }

    it "returns http success" do
      post :create, params: { restaurant_id: order.restaurant_id, id: order.id }
      expect(order.refunds.first.stripe_data).to eq(refund.stripe_data) 
    end
  end
end
