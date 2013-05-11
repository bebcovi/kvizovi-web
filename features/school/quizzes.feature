@school
Feature: Quizzes

  In order for the application to make sense for me
  As a school
  I want to be able to create quizzes

  Background:
    Given I'm registered and logged in

  Scenario: Creating, updating, and destroying quizzes
    When I create a quiz
    Then I should be on the quizzes page
    And I should see that quiz

    When I update that quiz
    Then I should be on the quizzes page
    And I should see the updated quiz

    When I delete that quiz
    Then I should be on the quizzes page
    And I should not see that quiz

  Scenario: Activating a quiz
    Given I have a quiz

    When I click on the link for deactivation
    Then I should be on the quizzes page
    And the quiz should not be activated

    When I click on the link for activation
    Then I should be on the quizzes page
    And the quiz should be activated
