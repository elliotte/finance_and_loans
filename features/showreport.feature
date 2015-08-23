Feature: showPageDetails

In order to see and use basic report information
As a user
I want to be able to see basic information

Background:
Given the admin user has a report
Given the user is logged in
Given I am on the homepage

Scenario:  viewAndAddValue
And I follow "New report testing" within "[@id='yourreports']"
And I follow "AddValue"
And I fill in the value
And I press "Create Value"
Then I should see "123.0" within "[@id='reportvalueswrap']"

Scenario: addAndViewDisclosure
And I follow "New report testing" within "[@id='yourreports']"
And I follow "AddDisclosure"
And I fill in the add report disclosure form correctly
And I press "Create Disclosure"
Then I should see "This is a text summary body" within "[@id='disclosureswrap']"

Scenario: reportDisclosureManagerEditSee
And I follow "New report testing" within "[@id='yourreports']"
And I follow "DisclosureManager"
And I fill in "disclosure[title]" with "TestingTitle"

Scenario: addReportComment
And I follow "New report testing" within "[@id='yourreports']"
And I follow "AddComment"
And I fill in "addComment" with "Testing comment"
And I press "Post comment"
Given I am on the homepage
And I follow "New report testing" within "[@id='yourreports']"
Then I should see "Testing comment" within "[@id='commentswrap']"