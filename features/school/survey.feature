@school
Feature: Survey

  In order to help out the developers of this application
  As a school
  I would like to provide them feedback through a survey

  Background:
    Given I'm registered and logged in

  Scenario: Completing survey
    When I click on the link for survey
    And I click on "Pošalji"
    Then I should still be on the survey page
    And I should see "Ne smije biti prazno"

    When I fill in the survey
    And I click on "Pošalji"
    Then I should be on the homepage
    And I should not see the link for the survey anymore
