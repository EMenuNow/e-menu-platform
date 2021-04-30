require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "Sign out button should exist if patron signed in" do    
    login_patron :with_password
    render_views

    it "GET #index" do
      get :index
      expect(response.body).to have_link("Signout", href: destroy_patron_session_path)
    end
  end

end
