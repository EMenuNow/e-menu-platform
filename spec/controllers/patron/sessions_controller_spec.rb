require 'rails_helper'

RSpec.describe Patrons::SessionsController, type: :controller do

  describe "After sign in redirect blank" do
    login_patron :with_password
    it "redirects back to previous page" do
      expect(controller.after_sign_in_path_for(@patron)).to eq(root_path)
    end
  end

  describe "Sign in with invalid credentials" do
    signup_patron :invalid_email

    it "redirects back to previous page" do
      expect(controller.after_sign_in_path_for(@patron)).to eq(root_path)
    end
  end

  describe "After sign in redirect restuarant page" do
    login_patron :sign_up_redirect, :with_password

    it "redirects back to previous page" do
      expect(controller.after_sign_in_path_for(@patron)).to eq(restaurant_path_path("lulus"))
    end
  end

  describe "Sign in without password" do
    login_patron_without_password

    it "Post #create" do
      expect(response).to have_http_status("302")
      expect(response).to redirect_to(root_path)
      expect(@patron.has_no_password).to eq(true)
    end
  end

  describe "Signup without password creates account" do
    signup_patron

    it "Post #create" do
      expect(response).to have_http_status("302")
      expect(response).to redirect_to(root_path)
      expect(@patron.has_no_password).to eq(true)
    end
  end

end
