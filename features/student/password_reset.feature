@student
Feature: Password reset

  In case I forget my password
  As a student
  I want to be able to reset it

  Background:
    Given I'm registered

  Scenario: Email request
    Given I didn't provide my email during registration
    When I log in
    Then I should be given a text field for putting my email

    When I fill in my email
    And I click on "Spremi"
    Then I should not see the text field anymore

  Scenario: Resetting password
    Given I have forgot my password
    When I request a new password
    Then I should get an email with the confirmation for resetting my password

    When I visit the confirmation URL
    Then I should get an email with my new password
    And I should be able to login with that password
