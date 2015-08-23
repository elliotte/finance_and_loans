Feature: AddingACompanyAsPowerUser

In order to have companyTeams
As a powerUser
I want to be able to addTeams

Background:
Given a superUser has already been created and logged in
Given I am on the homepage

@omniauth_test
Scenario: addAndEdit Company
And I follow "Companies"
And I follow "New Company"
And I fill in "Name" with "teamName"
And I fill in "Email" with "email@Company.com"
And I fill in "Company number" with "87654321"
And I press "Create Company"
Then I should see "teamName"
Then I should see "Company was successfully created"
And I follow "Edit"
And I fill in "Name" with "editedTeamName"
And I press "Update Company"
Then I should see "editedTeamName"


