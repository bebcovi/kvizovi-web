@school
Feature: Survey

  In order to help out the developers of this application
  As a school
  I would like to provide them feedback through a survey

  Background:
    Given I'm registered and logged in

  Scenario: Completing survey
    When I click on the link for survey
    And I complete the survey
    Then I should be on the homepage
    And I should not see the link for the survey anymore
