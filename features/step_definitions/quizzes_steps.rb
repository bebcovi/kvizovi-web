require "rack/test"

Given(/^(?:my|our) school has created a quiz for (?:me|us)$/) do
  @quiz = Factory.create(:quiz, school: @user.school)
  @quiz.questions = create_questions(6)
  refresh
end

Given(/^that school has created a quiz$/) do
  @quiz = Factory.create(:quiz, school: @other_school)
  @quiz.questions = create_questions(1)
  refresh
end

Given(/^I have a quiz$/) do
  @quiz = Factory.create(:quiz, school: @user)
  visit quizzes_url(subdomain: @user.type)
end

Given(/^that school(?: also)? has a quiz$/) do
  @other_quiz = Factory.create(:quiz, name: "Other quiz", school: @other_school)
  @question = Factory.create(:question, quiz: @other_quiz)
end

When(/^in the meanwhile the quiz gets deleted$/) do
  @quiz.destroy
end

When(/^I create a quiz$/) do
  click_on "Novi kviz"
  fill_in "Naziv", with: "Name"
  click_on "Spremi"
  @quiz = @user.quizzes.last
end

When(/^I update that quiz$/) do
  within(@quiz) { click_on "Izmijeni" }
  fill_in "Naziv", with: "Other name"
  click_on "Spremi"
end

When(/^I delete that quiz$/) do
  within(@quiz) { click_on "Izbriši" }
  click_on "Jesam"
end

When(/^I click on the link for (?:de)?activation$/) do
  within(@quiz) { find(".toggle-activation").click }
end

When(/^I click on the other school's quiz$/) do
  within(@other_quiz) { click_on "Pitanja" }
end

When(/^I choose to download a question to my quiz$/) do
  within(@question) { click_on "Preuzmi" }
  choose @quiz.name
  click_on "Preuzmi"
end

Then(/^I should be on the quizzes page$/) do
  expect(current_path).to eq quizzes_path
  expect(page.driver.request.request_method).to eq "GET"
end

Then(/^I should see that quiz$/) do
  expect(page).to have_content("Name")
end

Then(/^I should see the updated quiz$/) do
  expect(page).to have_content("Other name")
end

Then(/^I should not see that quiz$/) do
  expect(page).not_to have_content(@quiz.name)
end

Then(/^the quiz should (not )?be activated$/) do |negative|
  if negative
    expect(@quiz.reload).not_to be_activated
  else
    expect(@quiz.reload).to be_activated
  end
end

Then(/^I should(n't)? see (the other school's|my) quiz$/) do |negation, owner|
  quiz = owner == "my" ? @quiz : @other_quiz
  if negation.present?
    expect(page).not_to have_content(quiz.name)
  else
    expect(page).to have_content(quiz.name)
  end
end

Then(/^that question should be downloaded to my quiz$/) do
  visit quizzes_url(subdomain: @user.type)
  within(@quiz) { click_on "Pitanja" }
  expect(page).to have_content(@question.content)
end
