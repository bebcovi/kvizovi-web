@school
Feature: Questions

  In order to prepare quizzes for my students
  As a school I want to be able to create, update and delete questions

  Background:
    Given I'm registered
    And I'm logged in
    And I have a quiz

  Scenario: Adding, editing, and removing boolean questions
    When I visit the quizzes page
    When I click on "Pitanja" under quiz
    And I click on "Točno/netočno"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I choose "Točno"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a stupidhead?"

    When I click on "Izmijeni" under question
    And I fill in "Tekst pitanja" with "Are you a moron?"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a moron?"

    When I click on "Ukloni iz kviza" under question
    Then I should be on the questions page
    And I should not see "Are you a moron?"

  Scenario: Adding, editing, and removing choice questions
    When I visit the quizzes page
    When I click on "Pitanja" under quiz
    And I click on "Ponuđeni odgovori"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I fill in "Ponuđeni odgovor 1" with "No"
    And I fill in "Ponuđeni odgovor 2" with "Yes"
    And I fill in "Ponuđeni odgovor 3" with "Maybe"
    And I fill in "Ponuđeni odgovor 4" with "Probably not"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a stupidhead?"

    When I click on "Izmijeni" under question
    And I fill in "Tekst pitanja" with "Are you a moron?"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a moron?"

  Scenario: Adding, editing, and removing association questions
    When I visit the quizzes page
    When I click on "Pitanja" under quiz
    And I click on "Asocijacija"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I fill in "Asocijacija 1a" with "Uhm..."
    And I fill in "Asocijacija 1b" with "Yes"
    And I fill in "Asocijacija 2a" with "Uhm..."
    And I fill in "Asocijacija 2b" with "No"
    And I fill in "Asocijacija 3a" with "Uhm..."
    And I fill in "Asocijacija 3b" with "Maybe"
    And I fill in "Asocijacija 4a" with "Uhm..."
    And I fill in "Asocijacija 4b" with "Probably not"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a stupidhead?"

    When I click on "Izmijeni" under question
    And I fill in "Tekst pitanja" with "Are you a moron?"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a moron?"

  Scenario: Adding, editing, and removing image questions
    When I visit the quizzes page
    When I click on "Pitanja" under quiz
    And I click on "Pogodi tko/što je na slici"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I attach an image
    And I fill in "Odgovor" with "Yes"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a stupidhead?"

    When I click on "Izmijeni" under question
    And I fill in "Tekst pitanja" with "Are you a moron?"
    And I fill in the image url
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a moron?"

    And I click on "Ukloni iz kviza" under question

    And I click on "Pogodi tko/što je na slici"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I fill in the image url
    And I fill in "Odgovor" with "Yes"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a stupidhead?"

    When I click on "Izmijeni" under question
    And I fill in "Tekst pitanja" with "Are you a moron?"
    And I attach an image
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a moron?"

  Scenario: Adding, editing, and removing text questions
    When I visit the quizzes page
    When I click on "Pitanja" under quiz
    And I click on "Upiši točan odgovor"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I fill in "Odgovor" with "Yes"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a stupidhead?"

    When I click on "Izmijeni" under question
    And I fill in "Tekst pitanja" with "Are you a moron?"
    And I click on "Spremi"
    Then I should be on the questions page
    And I should see "Are you a moron?"
