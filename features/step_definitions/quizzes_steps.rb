require "rack/test"

Given(/^(?:my|our) school has created a quiz for (?:me|us)( with all types of questions)?$/) do |all_types|
  @quiz = FactoryGirl.create(:quiz, school: @user.school)
  @quiz.questions = create_questions(all_types ? 6 : 1)
end

Given(/^that school has created a quiz$/) do
  @quiz = FactoryGirl.create(:quiz, school: @other_school)
  @quiz.questions = create_questions(1)
end

Given(/^I have a quiz$/) do
  @quiz = FactoryGirl.create(:quiz, school: @user)
  visit account_quizzes_path
end

When(/^in the meanwhile the quiz gets deleted$/) do
  @quiz.destroy
end

When(/^I create a quiz$/) do
  click_on "Novi kviz"
  fill_in "Naziv", with: "Name"
  fill_in "Predmet", with: "Hrvatski jezik"
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

Then(/^I should be on the quizzes page$/) do
  expect(current_path).to eq account_quizzes_path
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
