require 'rails_helper'

RSpec.describe Restaurant::MenuController, type: :controller do

  describe "GET #index" do
    let (:restaurant) { FactoryBot.create(:restaurant) }

    it "returns http success" do
      get :index, params: { slug: restaurant.slug }
      expect(response).to have_http_status(:success)
      expect(controller.instance_variable_get(:@restaurant)).to eq(restaurant)
    end
  end

end
