@school
Feature: Blog

  In order to document website updates
  There should be a blog containing this documentation

  Scenario: Looking at the blog
    Given I'm registered
    And there is a new blog post

    When I log in
    Then I should see that I have an unread blog post

    When I visit the blog
    Then I should see the blog posts
    And I shouldn't see the admin links

    When I leave the blog
    Then I shouldn't have any unread blog posts

  Scenario: Managing blog posts
    Given I'm registered and logged in as an admin

    When I visit the blog
    Then I should see the admin links

    When I create a new blog post
    Then I should be on the posts page
    And I should see the new blog post

    When I update the blog post
    Then I should be on the posts page
    And I should see the updated blog post

    When I delete the blog post
    Then I should be on the posts page
    And I shouldn't see the blog post
