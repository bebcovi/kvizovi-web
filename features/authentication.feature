@school
Feature: Authentication

  As a developer
  I want users to be redirected to the loging page if they're not logged in

  Scenario: Visiting a page that requires login
    Given I'm registered
    When I visit my profile page
    Then I should be on the login page

    When I log in
    Then I should be on my profile page
