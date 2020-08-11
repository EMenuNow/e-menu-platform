 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/item_screens", type: :request do
  # ItemScreen. As you add validations to ItemScreen, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      ItemScreen.create! valid_attributes
      get item_screens_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      item_screen = ItemScreen.create! valid_attributes
      get item_screen_url(item_screen)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_item_screen_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      item_screen = ItemScreen.create! valid_attributes
      get edit_item_screen_url(item_screen)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ItemScreen" do
        expect {
          post item_screens_url, params: { item_screen: valid_attributes }
        }.to change(ItemScreen, :count).by(1)
      end

      it "redirects to the created item_screen" do
        post item_screens_url, params: { item_screen: valid_attributes }
        expect(response).to redirect_to(item_screen_url(ItemScreen.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new ItemScreen" do
        expect {
          post item_screens_url, params: { item_screen: invalid_attributes }
        }.to change(ItemScreen, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post item_screens_url, params: { item_screen: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested item_screen" do
        item_screen = ItemScreen.create! valid_attributes
        patch item_screen_url(item_screen), params: { item_screen: new_attributes }
        item_screen.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the item_screen" do
        item_screen = ItemScreen.create! valid_attributes
        patch item_screen_url(item_screen), params: { item_screen: new_attributes }
        item_screen.reload
        expect(response).to redirect_to(item_screen_url(item_screen))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        item_screen = ItemScreen.create! valid_attributes
        patch item_screen_url(item_screen), params: { item_screen: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested item_screen" do
      item_screen = ItemScreen.create! valid_attributes
      expect {
        delete item_screen_url(item_screen)
      }.to change(ItemScreen, :count).by(-1)
    end

    it "redirects to the item_screens list" do
      item_screen = ItemScreen.create! valid_attributes
      delete item_screen_url(item_screen)
      expect(response).to redirect_to(item_screens_url)
    end
  end
end