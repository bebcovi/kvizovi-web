@school
Feature: Profile

  In order to maintain my account
  As a school
  I need to be able to edit it

  Background:
    Given I'm registered and logged in
    And I'm on my profile

  Scenario: Updating profile
    When I click on "Izmijeni profil"
    And I update my profile
    Then I should see my updated profile

  Scenario: Updating password
    When I click on "Izmijeni lozinku"
    And I update my password
    And I log in again with the updated password
    Then I should be successfully logged in

  Scenario: Deleting the account
    When I click on "Izbriši korisnički račun"
    And I confirm my password
    Then I should be logged out
    And I should not be registered
