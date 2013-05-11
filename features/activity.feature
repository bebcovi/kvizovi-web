@school
Feature: Activity

  In order to see how people are doing
  As a developer
  I want to be able to track their last activity

  Scenario: Tracking last activity
    Given a user is registered and had some activity on the site
    When I visit the activity page
    Then I should see the time of his last activity

    When the user browses the site some more
    Then the time of his last activity should change
