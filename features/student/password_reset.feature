@student
Feature: Password reset

  In case I forget my password
  As a student
  I want to be able to reset it

  Background:
    Given I'm registered
    And I forgot my password

  Scenario: Resetting password
    When I request a new password
    Then my school should get an email with the confirmation for resetting my password

    When my school visits the confirmation URL
    Then I should get an email with my new password
    And I should be able to login with that password
