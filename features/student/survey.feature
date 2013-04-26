@student
Feature: Survey

  In order to help out the developers of this application
  As a student
  I would like to provide them feedback through a survey

  Background:
    Given I'm registered

  Scenario: Completing survey
    When I log in
    Then I should see the link for the survey

    When I complete the survey
    Then I should be on the homepage
    And I should not see the link for the survey anymore
