@school
Feature: Authentication

  Scenario: Registering
    When I go to the login page
    And I click on "Registrirajte se"
    And I authorize
    And I fill in the registration details
    And I click on "Registriraj se"
    Then I should be successfully logged in

  Scenario: Logging in
    Given I'm registered with username "janko" and password "secret"
    When I go to the homepage
    And I click on "Ja sam škola"
    And I fill in "Korisničko ime" with "janko"
    And I fill in "Lozinka" with "secret"
    And I click on "Prijava"
    Then I should be successfully logged in

    When I click on "Odjava"
    Then I should not be logged in

  Scenario: Resetting the password
    Given I'm registered with username "janko" and password "secret"
    When I go to the login page
    And I click on "Zatražite novu"
    And I confirm my email
    And I fill in "Korisničko ime" with "janko"
    And I fill in "Lozinka" with the emailed password
    And I click on "Prijava"
    Then I should be successfully logged in

  Scenario: Visiting a link when not logged in
    Given I'm registered
    When I go to the my profile page
    And I fill in my login information
    And I click on "Prijava"
    Then I should be on my profile page
