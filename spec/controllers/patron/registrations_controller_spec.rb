require 'rails_helper'

RSpec.describe Patrons::RegistrationsController, type: :controller do

  describe "After sign up redirect blank" do
    signup_patron :with_password

    it "redirects back to previous page" do
      expect(controller.after_sign_up_path_for(@patron)).to eq(root_path)
    end
  end

  describe "After sign up redirect restuarant page" do
    signup_patron :sign_up_redirect, :with_password

    it "redirects back to previous page" do
      expect(controller.after_sign_up_path_for(@patron)).to eq(restaurant_path_path("lulus"))
    end
  end

  describe "Sign up without password" do
    signup_patron

    it "Post #create" do
      expect(response).to have_http_status("302")
      expect(response).to redirect_to(root_path)
    end
  end

end
