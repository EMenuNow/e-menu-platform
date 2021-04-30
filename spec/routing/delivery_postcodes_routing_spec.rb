require "rails_helper"

RSpec.describe Manager::DeliveryPostcodesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/delivery_postcodes").to route_to("delivery_postcodes#index")
    end

    it "routes to #new" do
      expect(get: "/delivery_postcodes/new").to route_to("delivery_postcodes#new")
    end

    it "routes to #show" do
      expect(get: "/delivery_postcodes/1").to route_to("delivery_postcodes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/delivery_postcodes/1/edit").to route_to("delivery_postcodes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/delivery_postcodes").to route_to("delivery_postcodes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/delivery_postcodes/1").to route_to("delivery_postcodes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/delivery_postcodes/1").to route_to("delivery_postcodes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/delivery_postcodes/1").to route_to("delivery_postcodes#destroy", id: "1")
    end
  end
end
