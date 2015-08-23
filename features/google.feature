Feature: Google Search to explore poltergiest
  In order to expolre poltergeist functionality
  As a capybara and poltergeist user
  I want to see the if it works on Google search page

@javascript 
Scenario: View and search google home page
  Given I have went to the google homepage
  When I fill in some box "q" with "Ulster"
  And I press "Google Search"
  Then show me the page
  Then I should see "Google"