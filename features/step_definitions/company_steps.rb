
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



And(/^I fill report information$/) do
  fill_in("report_title",:with=> "Test Report")
end


When(/^I am redirecting to landing page$/) do
  visit auth_landing_welcome_index_path
end

When(/^I click on new work icon$/) do
  first("a[href='/reports/new.UKGAAP']").trigger('click')
end

Given(/^I have new work icon$/) do
  within(".slider-action-bar"){all("a")}.count==2
end

Then(/^I can see report options$/) do
  within(".slider-action-bar"){all("a")}.count==2
end

When(/^I click on IFRS report icon$/) do
  first("a[href='/reports/new.IFRS']").trigger('click')
end

Then(/^I can see modal popup for entries$/) do
  expect(page).to have_content "new BoardPack"
end

Then(/^I should be redirected to report show path with report create$/) do
  sleep 10
  current_url.should_not include("auth_landing")
end

When(/^I click on "(.*?)" button$/) do |arg1|
  find_button(arg1).trigger('click')  
end

When (/^I click on UK-GAAP report icon$/) do 
  first("a[href='/reports/new.UKGAAP']").trigger('click')
end




