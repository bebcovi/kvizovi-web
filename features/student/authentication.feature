@student
Feature: Authentication

  In order to use this website
  As a school
  I need some basic authentication-related features

  Scenario: Registering
    Given my school is registered
    When I go to the registration page
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in

  Scenario: Logging in
    Given I'm registered
    When I go to the login page
    And I fill in my login information
    And I click on "Prijava"
    Then I should be successfully logged in

    When I click on "Odjava"
    Then I should be logged out

  Scenario: Being redirected to the intended page after login
    Given I'm registered
    When I visit my profile page
    And I login
    Then I should be on my profile page
