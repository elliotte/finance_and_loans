require "spec_helper"

describe WelcomeHelper do
  describe "#get_login_url" do
    it "returns authorize url" do
    	expect(helper.get_login_url).to include("https://login.microsoftonline.com/common/oauth2/v2.0/authorize?")
    end
  end

  describe "#initialize_window_client" do
  	it "initialize client auth to get authorize url" do
    	expect(helper.initialize_window_client).to be_a OAuth2::Client
    end
  end
end