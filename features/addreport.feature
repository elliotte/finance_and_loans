@g_plus_stub
Feature: SettingUpReportWithValues

In order to collect information for a report
As a user
I want to be able to add a report

Background:
	Given a superUser has already been created and logged in

@javascript
Scenario:  addEditDeleteReport
	Given I am on auth_landing_welcome_index_url
	And I follow addReport
	And I follow Add a TB Value

@javascript @g_plus_stub
Scenario: Create a report after login
	Given I am redirecting to landing page
	And I have new work icon
	When I click on new work icon
	Then I can see report options
	When I click on IFRS report icon
	Then I can see modal popup for entries
	And I follow "addReport"
	And I follow "Add a TB Value"
	When I click on "Create Report" button
	Then I should be redirected to report show path with report create

Scenario: Create IFRS report from auth landing page
	Given I am on auth_landing_welcome_index
	And I have 	new work icon
	When I click on new work icon
	Then I can see report options
	When I click on UK-GAAP report icon
	Then I can see modal popup for entries
	And I add Report from modal
	When I click on "Create Report" button
	Then I should be redirected to report show path with report create

