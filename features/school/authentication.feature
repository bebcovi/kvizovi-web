@school
Feature: Authentication

  In order to use this website
  As a school
  I need basic authentication functionality

  Scenario: Registration
    When I go to the registration page
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in

  Scenario: Login
    Given I'm registered
    When I go to the login page
    And I fill in my login information
    And I click on "Prijava"
    Then I should be successfully logged in

    When I click on "Odjava"
    Then I should be logged out

  Scenario: Password reset
    Given I'm registered
    And I have forgot my password
    When I request a new password
    Then I should get an email with the confirmation for resetting my password

    When I visit the confirmation URL
    And I fill in a new password
    And I click on "Spremi"
    Then I should be successfully logged in
