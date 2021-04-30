require 'rails_helper'

RSpec.describe Patrons::PatronsController, type: :controller do

  describe "After sign in redirect blank" do
    login_patron :with_password

    it "#settings" do
      get :settings
      expect(controller.instance_variable_get(:@patron)).to eq(@patron)
    end
  end
end
