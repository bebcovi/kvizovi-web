@school
Feature: Students

  As a school
  I want to have an overview of my students

  Background:
    Given I'm registered and logged in

  Scenario: Getting the list of students
    Given I have some students
    When I go to the page for viewing students
    Then I should see those students
