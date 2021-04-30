require "rails_helper"

RSpec.describe Manager::ItemScreensController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/item_screens").to route_to("item_screens#index")
    end

    it "routes to #new" do
      expect(get: "/item_screens/new").to route_to("item_screens#new")
    end

    it "routes to #show" do
      expect(get: "/item_screens/1").to route_to("item_screens#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/item_screens/1/edit").to route_to("item_screens#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/item_screens").to route_to("item_screens#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/item_screens/1").to route_to("item_screens#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/item_screens/1").to route_to("item_screens#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/item_screens/1").to route_to("item_screens#destroy", id: "1")
    end
  end
end
