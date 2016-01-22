
Given(/^a superUser has already been created and logged in$/) do
  FactoryGirl.create(:user)
  visit('/')
  provider = 'google_oauth2'

  # client = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET']) do |b|
  #     b.request :url_encoded
  #     b.adapter :rack, Rails.application
  #   end

  #   token = client.password.get_token("vijayshriyuvasoft139@gmail.com", "qwxhxzwemednfudo")
  #   token.should_not be_expired
  OmniAuth.config.add_mock(provider, {uid: '12345678', provider: provider})
  #click_on('Sign in with Google')
end

