@school
Feature: Questions

  In order for the application to make sense for me
  As a school
  I want to be able to create questions in my quizzes

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
      | question                          |
      | a boolean question                |
      | a choice question                 |
      | an association question           |
      | an image question with image url  |
      | an image question with image file |
      | a text question                   |

  Scenario: Undoing question delete
    When I create an image question
    And I delete that question
    Then I should see an undo link

    When I click on the undo link
    Then I should see that question again
