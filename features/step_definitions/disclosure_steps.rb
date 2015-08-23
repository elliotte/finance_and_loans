Given(/^a disclosure has already been added$/) do
	Report.last.disclosures << FactoryGirl.create(:disclosure) 
end

Given(/^I uncheck the disclosure active box$/) do
 	first(:css, "#disclosure_active").set(false)
end

Given(/^a director's disclosure has already been added$/) do
  Report.last.disclosures << FactoryGirl.create(:director_report) 
end

Then(/^I uncheck the directors disclosure active box$/) do
	first(:css, "#director_report_active").set(false)
end

Given(/^I press the "(.*?)" button for this disclosure$/) do |button_name|
   first(:button, button_name).click
end

Then(/^I should not see the disclosure as active$/) do
  first(:css, "#director_report_active").value.should == 0
end

Then(/^I select "(.*?)" from "(.*?)" for this disclosure$/) do |drop_box, dropdown_option|
  drop_menu = first(:css, drop_box)
  select dropdown_option, from: drop_menu
end
