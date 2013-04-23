@school
Feature: Questions

  Background:
    Given I'm registered and logged in
    And I have a quiz

  Scenario Outline: A school can create, edit, and destroy questions
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

  Scenario: A school undo a question delete
    When I create an image question
    And I delete that question
    Then I should see "Vrati"

    When I click on "Vrati"
    Then I should see that question again
