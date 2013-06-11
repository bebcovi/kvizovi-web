@student
Feature: Login

  In order to use this website
  As a student
  I need to be able to login

  Scenario: Logging in
    Given I'm registered
    When I go to the login page
    And I fill in my login information
    And I click on "Prijava"
    Then I should be successfully logged in

    When I click on "Odjava"
    Then I should be logged out
