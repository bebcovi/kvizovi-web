@student
Feature: Profile

  Background:
    Given I'm registered with username "janko" and password "secret"
    And I'm logged in
    And I click on "Uredi profil"

  Scenario: Updating profile
    When I click on "Izmijeni profil"
    And I fill in "Ime" with "New name"
    And I click on "Spremi"
    Then I should see "New name"

  Scenario: Updating password
    When I click on "Izmijeni lozinku"
    And I fill in "Stara lozinka" with "secret"
    And I fill in "Nova lozinka" with "new password"
    And I fill in "Potvrda nove lozinke" with "new password"
    And I click on "Spremi"
    And I log out
    And I go to the login page
    And I fill in "Korisničko ime" with "janko"
    And I fill in "Lozinka" with "new password"
    And I click on "Prijava"
    Then I should be successfully logged in

  Scenario: Deleting account
    When I click on "Izbriši korisnički račun"
    And I confirm my password
    Then I should not be logged in
    And I should not be registered

