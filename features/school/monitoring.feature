@school
Feature: Monitoring

  In order to see what my students are doing
  As a school
  I want to be able to monitor their activity on quizzes

  Background:
    Given I'm registered and logged in

  Scenario: Monitoring through quizzes
    Given my students have played a quiz
    When I go to the page for monitoring that quiz
    Then I should see that they played that quiz

    When I click on the played quiz
    Then I should see their results

  Scenario: Monitoring through students
    Given my student has played a quiz
    When I go to the page for monitoring that student's activity
    Then I should see that he played that quiz

    When I click on the played quiz
    Then I should see his results

  Scenario: Viewing played quizzes
    Given my students have played a quiz realistically
    When I go to that played quiz
    Then I should see their results
