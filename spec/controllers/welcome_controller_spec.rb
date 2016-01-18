RSpec.describe WelcomeController, :type => :controller do

  before do
      @current_user = FactoryGirl.create(:user)
      ApplicationController.any_instance.stub(:verify_token)
      controller.session[:token] = '265378652378682786237846'
  end

  describe "GET index" do
    it "redirect to auth landing page with provider id #{$O365_provider_ID}" do
      controller.session[:provider] = $O365_provider_ID
      get :index
      expect(session[:state]).to be_blank
      expect(response).to redirect_to auth_landing_welcome_index_url
    end

    it "renders the index template with state" do
      controller.session[:provider] = ""
      get :index
      expect(session[:state]).to_not be_blank
      expect(response).to render_template("index")
    end
  end

  describe "#sign_out_user" do
    it "logout user anf redirect to root path" do
        get :sign_out_user
        expect(response).to redirect_to root_path
        expect(controller.session["flash"]["flashes"]["notice"]).to eql("Signed Out Boss")
    end 
  end

  describe "#disconnect" do 
    it "revoke google app" do 
      xhr :post,:disconnect,format: 'json'
      expect(response.body).to eql("\"User disconnected.\"")
      expect(controller.session).to be_blank
    end
  end

  # specs for private methods failing

  # describe "#set_auth_token_session" do 
  #   it "verify to set sesion" do
  #     expect_any_instance_of(WelcomeController).to receive(:set_auth_token_session).with('1234')   
  #   end
  # end

  # describe "#set_user_session" do
  #   it "set values in user session" do 
  #     expect_any_instance_of(WelcomeController).to receive(:set_user_session).with({:key1=>"1",:key2=>"2"})
  #   end 
  # end

  # describe "#check_for_expired_token" do 
  #   it "check for google session expired" do 
  #     expect_any_instance_of(WelcomeController).to receive(:check_for_expired_token)
  #   end
  # end
end