@student
Feature: Authentication

  Scenario: A student can register
    Given my school is registered
    When I go to the login page
    And I click on "Registriraj se"
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in

  Scenario: A student can log in and log out
    Given I'm registered
    When I go to the homepage
    And I click on "Ja sam učenik"
    And I fill in my login information
    And I click on "Prijava"
    Then I should be successfully logged in

    When I click on "Odjava"
    Then I should be logged out

  Scenario: After authentication the student is redirected to the intended page
    Given I'm registered
    When I visit my profile page
    And I authenticate
    Then I should be on my profile page
