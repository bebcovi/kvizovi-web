Given(/^I'm logged in$/) do
  step "I go to my profile page"
  step "I fill in my login information"
  click_on "Prijava"
end

When(/^I log out$/) do
  click_on "Odjava"
end

When(/^I fill in my login information/) do
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: @user.password
end

Then(/^I should be successfully logged in$/) do
  school  { expect(current_path).to eq quizzes_path }
  student { expect(current_path).to eq new_game_path }
end

Then(/^I should not be logged in$/) do
  expect(current_path).to eq root_path
end
