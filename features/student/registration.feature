@student
Feature: Registration

  In order to use this website
  As a student
  I need to be able to register

  Scenario: Registering
    Given my school is registered
    When I go to the registration page
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in
