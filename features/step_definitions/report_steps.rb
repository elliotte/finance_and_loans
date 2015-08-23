Given(/^a report has already been added$/) do
	user = User.last
	user.reports << FactoryGirl.create(:report)
end

Given(/^I follow the show report icon$/) do
  find('.cardshow')
end

Given(/^I fill in the value$/) do
 fill_in("value[amount]", :with => "123.0")
end

Given(/^I fill in the form correctly$/) do
	fill_in("Title", :with => "Report title text for test")
	fill_in("Summary", :with => "This is a text summary")
end

Given(/^I fill in the add report disclosure form correctly$/) do
  	fill_in("disclosure[title]", :with => "Testing Title")
	fill_in("disclosure[body]", :with => "This is a text summary body")
end


Given(/^I on the reports index page$/) do
	visit('/reports')
end

Given(/^an user badline has been added$/) do
	user = User.last
	user.badlines << FactoryGirl.create(:badline) 
end

Then(/^I follow the reports "(.*?)" link$/) do |link_id|
  first(:link, link_id).click
end

Given(/^I fill out the get finstats form$/) do
  find('#getfinstats').select('April', from: "yearOne_month")
  find('#getfinstats').select('April', from: "yearTwo_month")
  find('#getfinstats').select('2014', from: "yearOne_year")
  find('#getfinstats').select('2015', from: "yearTwo_year")
end

Given(/^I fill out the form with many values$/) do
	fill_in("Title", :with => "Report many values test")
	fill_in("Summary", :with => "This is a text summary")
	find('#report_values_attributes_0_repdate_2i').select('April')
	find('#report_values_attributes_0_repdate_1i').select('2015')
	find('#report_values_attributes_0_badline').select('Intangible assets')
	fill_in('report[values_attributes][0][amount]', :with => "10000.00")
	find('#report_values_attributes_1_repdate_2i').select('April')
	find('#report_values_attributes_1_repdate_1i').select('2014')
	find('#report_values_attributes_1_badline').select('Intangible assets')
	fill_in('report[values_attributes][1][amount]', :with => "50000.00")
	find('#report_values_attributes_2_repdate_2i').select('April')
	find('#report_values_attributes_2_repdate_1i').select('2014')
	find('#report_values_attributes_2_badline').select('Cash')
	fill_in('report[values_attributes][2][amount]', :with => "50000.00")
	find('#report_values_attributes_3_repdate_2i').select('April')
	find('#report_values_attributes_3_repdate_1i').select('2015')
	find('#report_values_attributes_3_badline').select('Cash')
	fill_in('report[values_attributes][3][amount]', :with => "30000.00")
end

Given(/^I fill out the form with many many values$/) do
  	fill_in("Title", :with => "Report many many values test")
	fill_in("Summary", :with => "This is a text summary")
	find('#report_values_attributes_0_repdate_2i').select('April')
	find('#report_values_attributes_0_repdate_1i').select('2015')
	find('#report_values_attributes_0_badline').select('Intangible assets')
	fill_in('report[values_attributes][0][amount]', :with => "10000.00")
	find('#report_values_attributes_1_repdate_2i').select('April')
	find('#report_values_attributes_1_repdate_1i').select('2014')
	find('#report_values_attributes_1_badline').select('Intangible assets')
	fill_in('report[values_attributes][1][amount]', :with => "50000.00")
	find('#report_values_attributes_2_repdate_2i').select('April')
	find('#report_values_attributes_2_repdate_1i').select('2014')
	find('#report_values_attributes_2_badline').select('Cash')
	fill_in('report[values_attributes][2][amount]', :with => "50000.00")
	find('#report_values_attributes_3_repdate_2i').select('April')
	find('#report_values_attributes_3_repdate_1i').select('2015')
	find('#report_values_attributes_3_badline').select('Cash')
	fill_in('report[values_attributes][3][amount]', :with => "30000.00")
	find('#report_values_attributes_4_repdate_2i').select('April')
	find('#report_values_attributes_4_repdate_1i').select('2015')
	find('#report_values_attributes_4_badline').select('Intangible assets')
	fill_in('report[values_attributes][4][amount]', :with => "10000.00")
	find('#report_values_attributes_5_repdate_2i').select('April')
	find('#report_values_attributes_5_repdate_1i').select('2014')
	find('#report_values_attributes_5_badline').select('Intangible assets')
	fill_in('report[values_attributes][5][amount]', :with => "50000.00")
	find('#report_values_attributes_6_repdate_2i').select('April')
	find('#report_values_attributes_6_repdate_1i').select('2014')
	find('#report_values_attributes_6_badline').select('Cash')
	fill_in('report[values_attributes][6][amount]', :with => "50000.00")
	find('#report_values_attributes_7_repdate_2i').select('April')
	find('#report_values_attributes_7_repdate_1i').select('2015')
	find('#report_values_attributes_7_badline').select('Cash')
	fill_in('report[values_attributes][7][amount]', :with => "30000.00")
	find('#report_values_attributes_7_repdate_2i').select('April')
	find('#report_values_attributes_7_repdate_1i').select('2015')
	find('#report_values_attributes_7_badline').select('Intangible assets')
	fill_in('report[values_attributes][7][amount]', :with => "10000.00")
	find('#report_values_attributes_6_repdate_2i').select('April')
	find('#report_values_attributes_6_repdate_1i').select('2014')
	find('#report_values_attributes_6_badline').select('Intangible assets')
	fill_in('report[values_attributes][6][amount]', :with => "50000.00")
	find('#report_values_attributes_5_repdate_2i').select('April')
	find('#report_values_attributes_5_repdate_1i').select('2014')
	find('#report_values_attributes_5_badline').select('Cash')
	fill_in('report[values_attributes][5][amount]', :with => "50000.00")
	find('#report_values_attributes_4_repdate_2i').select('April')
	find('#report_values_attributes_4_repdate_1i').select('2015')
	find('#report_values_attributes_4_badline').select('Cash')
	fill_in('report[values_attributes][4][amount]', :with => "30000.00")
	find('#report_values_attributes_3_repdate_2i').select('April')
	find('#report_values_attributes_3_repdate_1i').select('2015')
	find('#report_values_attributes_3_badline').select('Intangible assets')
	fill_in('report[values_attributes][3][amount]', :with => "10000.00")
	find('#report_values_attributes_2_repdate_2i').select('April')
	find('#report_values_attributes_2_repdate_1i').select('2014')
	find('#report_values_attributes_2_badline').select('Intangible assets')
	fill_in('report[values_attributes][2][amount]', :with => "50000.00")
	find('#report_values_attributes_1_repdate_2i').select('April')
	find('#report_values_attributes_1_repdate_1i').select('2014')
	find('#report_values_attributes_1_badline').select('Cash')
	fill_in('report[values_attributes][1][amount]', :with => "50000.00")
	find('#report_values_attributes_0_repdate_2i').select('April')
	find('#report_values_attributes_0_repdate_1i').select('2015')
	find('#report_values_attributes_0_badline').select('Cash')
	fill_in('report[values_attributes][0][amount]', :with => "30000.00")
end

# Given(/^I fill in the first amount with "(.*?)"$/) do |amount|
#   field = find('#report_values_attributes_0_amount')
#   fill_in(field, :with => amount)
# end