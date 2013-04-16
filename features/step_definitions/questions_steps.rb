require "active_support/core_ext/string/strip"

Given(/^I have a quiz$/) do
  @quiz = FactoryGirl.create(:quiz, school: @user)
end

Given(/^I click on "(.*)" under the question/) do |text|
  within(@quiz.questions.first) { click_on text }
end

Given(/^I attach an image$/) do
  attach_file "Slika", Rails.root.join("spec/fixtures/files/image.jpg")
end

Given(/^I fill in the image url$/) do
  fill_in "URL od slike", with: "http://3.bp.blogspot.com/-bnKL0iosAc8/UOmO_a_ujuI/AAAAAAAAmVI/R5aNBx_yx2w/s1600/flbp-girls-women-sexy-9.jpg"
end

Given(/^I have created an image question$/) do
  steps %Q{
    When I visit the questions page
    And I click on "Pogodi tko/što je na slici"
    And I fill in "Tekst pitanja" with "Are you a stupidhead?"
    And I attach an image
    And I fill in "Odgovor" with "yes"
    And I click on "Spremi"
  }.strip_heredoc.encode("UTF-8")
end

Then(/^I should see my question again$/) do
  step %Q{I should see "#{@quiz.questions.last.content}"}
end
