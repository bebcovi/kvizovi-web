@student
Feature: Playing quizzes

  Background:
    Given I'm registered and logged in
    And my school has created a quiz for me

  Scenario: A student can play a quiz in single player
    When I visit the page for playing quizzes
    When I choose the quiz that my school has created for me
    And I choose to play alone
    And I click on "Započni kviz"
    Then I should see the first question

    When I answer all questions correctly
    Then I should get all points

  Scenario: A student can play a quiz in multi player
    Given another student is registered
    When I visit the page for playing quizzes
    When I choose the quiz that my school has created for me
    And I choose to play with the other student
    And I click on "Započni kviz"
    Then we should see the first question

    When we answer all questions correctly
    Then we should get all points

  Scenario: A student may not get all points
    When I start the quiz
    And I answer all questions incorrectly
    Then I should not get any points

  Scenario: A student can abort playing the quiz
    When I start the quiz
    And I interrupt the game
    Then I should be on the page for playing quizzes
