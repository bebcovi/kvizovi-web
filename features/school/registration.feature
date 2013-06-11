@school
Feature: Registration

  In order to use this website
  As a school
  I need to be able to register

  Scenario: Registering
    When I go to the registration page
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in
