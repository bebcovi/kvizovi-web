@student
Feature: Playing quizzes

  In order for the application to make sense for me
  As a student
  I want to be able to play quizzes

  Background:
    Given I'm registered and logged in

  Scenario: Single player
    Given my school has created a quiz for me with all types of questions
    When I begin the quiz in single player
    And I answer all questions correctly
    Then I should get all points

  Scenario: Multi player
    Given our school has created a quiz for us with all types of questions
    When we begin the quiz in multi player
    And we answer all questions correctly
    Then we should get all points

  Scenario: Not getting all points
    Given my school has created a quiz for me with all types of questions
    When I begin the quiz
    And I answer all questions incorrectly
    Then I should not get any points

  Scenario: Aborting
    Given my school has created a quiz for me
    When I begin the quiz
    And I interrupt it
    Then I should be on the page for playing quizzes

  Scenario: The quiz gets deleted in the meanwhile
    Given my school has created a quiz for me
    When I begin the quiz
    But in the meanwhile the quiz gets deleted
    Then I should still be able to play it

  Scenario: Playing quizzes from other schools
    Given there is another school registered
    And that school has created a quiz
    Then I should see that quiz in the list of available quizzes
    And I should be able to play it
