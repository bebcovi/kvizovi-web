@student
Feature: Profile

  In order to maintain my account
  As a student
  I need to be able to edit it

  Background:
    Given I'm registered and logged in
    And I'm on my profile

  Scenario: Updating profile
    When I click on "Izmijeni profil"
    And I update my profile
    Then I should see my updated profile

  Scenario: Deleting the account
    When I click on "Izbriši korisnički račun"
    Then I should be logged out
    And I should not be registered
