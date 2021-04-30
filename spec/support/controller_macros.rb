module ControllerMacros
  def login_manager(restaurant_user: nil)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:restaurant_user]
      sign_in @restaurant_user = (restaurant_user || FactoryBot.create(:restaurant_user))
    end
  end

  def login_patron(*args)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:patron]
      sign_in @patron = FactoryBot.create(:patron, *args)
    end
  end

  def login_patron_without_password(*args)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:patron]
      @patron = FactoryBot.create(:patron, *args)
      post :create, :params => { "patron": @patron.as_json }
    end
  end

  def signup_patron(*args)
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:patron]
      @patron = FactoryBot.build(:patron, *args)
      post :create, :params => { "patron": @patron.as_json }
    end
  end
end
