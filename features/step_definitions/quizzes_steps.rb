Given(/^I have a quiz$/) do
  @quiz = Factory.create(:quiz, school: @user)
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
