require "rails_helper"

RSpec.describe Patrons::SessionsController, type: :routing do
  describe "routing" do
    it "routes to #sign_in" do
      expect(:get => "/patrons/sign_in").to route_to("patrons/sessions#new")
    end
  end
  describe "routing" do
    it "routes to #sign_in" do
      expect(:get => "/patrons/sign_up").to route_to("devise/registrations#new")
    end
  end
end
