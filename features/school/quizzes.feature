@school
Feature: Quizzes

  In order to prepare quizzes for my students
  As a school
  I want to be able to create, update and delete quizzes

  Background:
    Given I'm registered
    And I'm logged in

  Scenario: Creating, updating and deleting quizzes
    When I click on "Novi kviz"
    And I fill in "Naziv" with "Some name"
    And I click on "Spremi"
    Then I should see "Some name"

    When I click on "Izmijeni"
    And I fill in "Naziv" with "Some other name"
    And I click on "Spremi"
    Then I should see "Some other name"

    When I click on "Izbriši"
    And I click on "Jesam"
    Then I should not see "Some other name"
