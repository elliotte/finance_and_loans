
Given(/^a superUser has already been created and logged in$/) do
  visit('/')
  page.set_rack_session(token: '265378652378682786237846')
  page.set_rack_session(provider: 'googleoauth2')
  # client = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET']) do |b|
  #     b.request :url_encoded
  #     b.adapter :rack, Rails.application
  #   end

  #   token = client.password.get_token("vijayshriyuvasoft139@gmail.com", "qwxhxzwemednfudo")
  #   token.should_not be_expired
  #OmniAuth.config.add_mock(provider, {uid: '12345678', provider: provider})
  #click_on('Sign in with Google')
end



And(/^I follow addReport$/) do
  pending
end


When(/^I am redirecting to landing page$/) do
  visit auth_landing_welcome_index_path
end

When(/^I click on new work icon$/) do
  pending # express the regexp above with the code you wish you had
end


