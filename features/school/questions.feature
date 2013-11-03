@school
Feature: Questions

  In order to create quizzes for my students
  As a school
  I want to be able to create questions for those quizzes

  Background:
    Given I'm registered and logged in
    And I have a quiz

  Scenario Outline: Creating, updating and destroying questions
    When I create <question>
    Then I should be on the questions page
    And I should see that question

    When I update that question
    Then I should be on the questions page
    And I should see the updated question

    When I delete that question
    Then I should be on the questions page
    And I should not see that question

    Examples:
      | question                |
      | a boolean question      |
      | a choice question       |
      | an association question |
      | a text question         |

  Scenario: Ordering questions
    Given my quiz has some questions
    When I go to the questions page
    And I click on "Izmijeni redoslijed"
    And I change the order of my questions
    And I click on "Spremi"
    Then I should be on the questions page
    And the order of questions should be different
