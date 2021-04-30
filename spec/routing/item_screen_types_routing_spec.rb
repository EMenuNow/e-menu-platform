require "rails_helper"

RSpec.describe Manager::ItemScreenTypesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/item_screen_types").to route_to("item_screen_types#index")
    end

    it "routes to #new" do
      expect(get: "/item_screen_types/new").to route_to("item_screen_types#new")
    end

    it "routes to #show" do
      expect(get: "/item_screen_types/1").to route_to("item_screen_types#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/item_screen_types/1/edit").to route_to("item_screen_types#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/item_screen_types").to route_to("item_screen_types#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/item_screen_types/1").to route_to("item_screen_types#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/item_screen_types/1").to route_to("item_screen_types#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/item_screen_types/1").to route_to("item_screen_types#destroy", id: "1")
    end
  end
end
