Given(/^I follow the login steps$/) do
  #find_button(".g-signin").trigger('click')
  #puts page.execute_script(%Q{ $('.g-signin').click() }).to_i.inspect
  #first(:xpath, '//button[@class="g-signin"]').trigger('click')
  save_and_open_page
end

Given(/^an admin user has already been added$/) do
	FactoryGirl.create(:user)
end

Given(/^the admin user has a report$/) do
 	FactoryGirl.create(:user, reports: [FactoryGirl.create(:report_with_values_cash_badline)])
end

Given(/^a user is logged in$/) do
  visit('/ledgers')
  save_and_open_page
end