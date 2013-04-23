@school
Feature: Quizzes

  Background:
    Given I'm registered and logged in

  Scenario: A school can create, update and delete quizzes
    When I create a quiz
    Then I should be on the quizzes page
    And I should see that quiz

    When I update that quiz
    Then I should be on the quizzes page
    And I should see the updated quiz

    When I delete that quiz
    Then I should be on the quizzes page
    And I should not see that quiz
