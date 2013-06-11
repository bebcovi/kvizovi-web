@school
Feature: Survey

  In order to help out the developers of this application
  As a school
  I want to provide them feedback through a survey

  Background:
    Given I'm registered and logged in

  Scenario: Completing survey
    When I visit my homepage
    Then I should see link "Anketa"

    When I click on "Anketa"
    And I fill in the survey
    And I click on "Pošalji"
    Then I should be on the homepage
    And I should not see link "Anketa"
