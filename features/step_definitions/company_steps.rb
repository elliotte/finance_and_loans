
Given(/^a superUser has already been created and logged in$/) do
  FactoryGirl.create(:google_user_admin)
  visit('/')
  provider = 'google_oauth2'
  OmniAuth.config.add_mock(provider, {uid: '12345678', provider: provider})
  click_on('Sign in with Google')
end

