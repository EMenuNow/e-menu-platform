require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe "Interactions with Order" do
    it "GET #index" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
