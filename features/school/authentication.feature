@school
Feature: Authentication

  Scenario: A school can register
    When I go to the login page
    And I click on "Registrirajte se"
    And I authorize
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in

  Scenario: A school can log in and log out
    Given I'm registered
    When I go to the homepage
    And I click on "Ja sam škola"
    And I fill in my login information
    And I click on "Prijava"
    Then I should be successfully logged in

    When I click on "Odjava"
    Then I should be logged out

  Scenario: A school can reset its password
    Given I'm registered
    When I go to the login page
    And I click on "Zatražite novu"
    And I confirm my email
    And I fill in my login information with the emailed password
    And I click on "Prijava"
    Then I should be successfully logged in

  Scenario: After authentication the school is redirected to the intended page
    Given I'm registered
    When I visit my profile page
    And I authenticate
    Then I should be on my profile page
