@school
Feature: Profile

  Background:
    Given I'm registered and logged in
    And I click on "Uredi profil"

  Scenario: A school can update its profile
    When I click on "Izmijeni profil"
    And I update my name
    Then I should see my new name

  Scenario: A school can update its password
    When I click on "Izmijeni lozinku"
    And I update my password
    And I log out
    And I go to the login page
    And I fill in my login information with the updated password
    And I click on "Prijava"
    Then I should be successfully logged in

  Scenario: A school can delete its account
    When I click on "Izbriši korisnički račun"
    And I confirm my password
    Then I should be logged out
    And I should not be registered
