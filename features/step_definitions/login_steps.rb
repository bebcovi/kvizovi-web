Given(/^I'm logged in$/) do
  visit login_url(subdomain: @user_type)
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: @user.password
  click_on "Prijava"
end

When(/^I go to the login page/) do
  visit root_url
  school  { click_on "Ja sam škola" }
  student { click_on "Ja sam učenik" }
end

When(/^I login$/) do
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: @user.password
  click_on "Prijava"
end

When(/^I log out$/) do
  click_on "Odjava"
end

When(/^I fill in my login information$/) do
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: @user.password
end

Then(/^I should be successfully logged in$/) do
  school  { expect(current_path).to eq quizzes_path }
  student { expect(current_path).to eq new_game_path }
end

Then(/^I should be logged out$/) do
  expect(page).to have_content("Ja sam škola")
  expect(page).to have_content("Ja sam učenik")
end
