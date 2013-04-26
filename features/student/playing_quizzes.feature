@student
Feature: Playing quizzes

  In order for the application to make sense for me
  As a student
  I want to be able to play quizzes

  Background:
    Given I'm registered and logged in
    And my school has created a quiz for me

  Scenario: Single player
    When I begin the quiz in single player
    And I answer all questions correctly
    Then I should get all points

  Scenario: Multi player
    When I begin the quiz in multi player
    And we answer all questions correctly
    Then we should get all points

  Scenario: Not getting all points
    When I begin the quiz
    And I answer all questions incorrectly
    Then I should not get any points

  Scenario: Aborting
    When I begin the quiz
    And I interrupt it
    Then I should be on the page for playing quizzes
