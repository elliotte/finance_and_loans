Given(/^I have went to the google homepage$/) do
  puts visit "http://www.google.com"
end

When(/^I fill in some box "(.*?)" with "(.*?)"$/) do |element, text|
  fill_in element, with: text
end
