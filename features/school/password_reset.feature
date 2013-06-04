@school
Feature: Password reset

  In case I forget my password
  As a school
  I want to be able to reset it

  Background:
    Given I'm registered

  Scenario: Resetting password
    Given I have forgot my password
    When I request a new password
    Then I should get an email with the confirmation for resetting my password

    When I visit the confirmation URL
    Then I should get an email with my new password
    And I should be able to login with that password
