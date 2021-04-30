require "rails_helper"

RSpec.describe Manager::PiInterfacesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/pi_interfaces").to route_to("pi_interfaces#index")
    end

    it "routes to #new" do
      expect(get: "/pi_interfaces/new").to route_to("pi_interfaces#new")
    end

    it "routes to #show" do
      expect(get: "/pi_interfaces/1").to route_to("pi_interfaces#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/pi_interfaces/1/edit").to route_to("pi_interfaces#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/pi_interfaces").to route_to("pi_interfaces#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/pi_interfaces/1").to route_to("pi_interfaces#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/pi_interfaces/1").to route_to("pi_interfaces#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/pi_interfaces/1").to route_to("pi_interfaces#destroy", id: "1")
    end
  end
end
