Feature: SettingUpReportWithValues

In order to collect information for a report
As a user
I want to be able to add a report

Background:
Given an admin user has already been added
Given the user is logged in

@javascript
Scenario:  addEditDeleteReport
Given I am on the homepage
And I follow "addReport"
And I follow "Add a TB Value"
