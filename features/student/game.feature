@student
Feature: Game

  In order to enjoy playing awesome quizzes
  As a student
  I don't want to experience some lame errors

  Background:
    Given I'm registered
    And I'm logged in
    And my school has created a quiz for me named "Random questions"

    And that quiz has the following choice questions
      | content                                | provided_answers                               |
      | Who is the cutest person in the world? | ["Kina Grannis", "Me", "Jon Lajoie", "Matija"] |

    And that quiz has the following association questions
      | content           | associations                                                                            |
      | Connect browsers: | {"Opera" => "Weird", "IE" => "Terrible as fuck", "Chrome" => "Best", "Firefox" => "OK"} |

    And that quiz has the following boolean questions
      | content                         | answer |
      | This website is fucking awesome | true   |

    And that quiz has the following image questions
      | content              | image              | answer         |
      | Who is in the photo? | clint_eastwood.jpg | Clint Eastwood |

    And that quiz has the following text questions
      | content                            | answer |
      | What's Mr. Andersen's hacker name? | Neo    |

    And that quiz has the following text questions
      | content                                  | answer |
      | What was Smith's name in the real world? | Bane   |

  Scenario: Answering all questions correctly
    Given another player is registered
    When I visit the page for playing quizzes
    And I choose "Random questions"
    And I choose "Još netko"
    And I fill in other player's credentials
    And I click on "Započni kviz"
    Then I should see "Who is the cutest person in the world?"

    When I choose "Kina Grannis"
    And I click on "Odgovori"
    Then I should see "Točan odgovor"

    When I click on "Sljedeće pitanje"
    And I connect "IE" with "Terrible as fuck"
    And I connect "Opera" with "Weird"
    And I connect "Firefox" with "OK"
    And I connect "Chrome" with "Best"
    And I click on "Odgovori"
    Then I should see "Točan odgovor"

    When I click on "Sljedeće pitanje"
    And I choose "Točno"
    And I click on "Odgovori"
    Then I should see "Točan odgovor"

    When I click on "Sljedeće pitanje"
    And I fill in "Odgovor" with "Clint Eastwood"
    And I click on "Odgovori"
    Then I should see "Točan odgovor"

    When I click on "Sljedeće pitanje"
    And I fill in "Odgovor" with "Neo"
    And I click on "Odgovori"
    Then I should see "Točan odgovor"

    When I click on "Sljedeće pitanje"
    And I fill in "Odgovor" with "Bane"
    And I click on "Odgovori"
    Then I should see "Točan odgovor"

    When I click on "Rezultati"
    Then I should see "3 od 3"
    And I should not see "2 od 3"
    And I should not see "1 od 3"
    And I should not see "0 od 3"

    When I click on "Završi"
    Then I should be on the page for playing quizzes

  Scenario: Answering some answers incorrecly
    When I visit the page for playing quizzes
    And I choose "Random questions"
    And I choose "Samo ja"
    And I click on "Započni kviz"
    Then I should see "Who is the cutest person in the world?"

    And I click on "Odgovori"
    Then I should not see "Točan odgovor!"

    When I click on "Sljedeće pitanje"
    And I click on "Odgovori"
    Then I should not see "Točan odgovor!"

    When I click on "Sljedeće pitanje"
    And I click on "Odgovori"
    Then I should not see "Točan odgovor!"

    When I click on "Sljedeće pitanje"
    And I click on "Odgovori"
    Then I should not see "Točan odgovor!"

    When I click on "Sljedeće pitanje"
    And I click on "Odgovori"
    Then I should not see "Točan odgovor!"

    When I click on "Sljedeće pitanje"
    And I click on "Odgovori"
    Then I should not see "Točan odgovor!"

    When I click on "Rezultati"
    Then I should see "0 od 6"

  Scenario: Aborting the game
    When I visit the page for playing quizzes
    And I choose "Random questions"
    And I choose "Samo ja"
    And I click on "Započni kviz"
    And I click on "Prekini"
    And I click on "Jesam"
    Then I should not see "0 od 6"
    And I should be on the page for playing quizzes
