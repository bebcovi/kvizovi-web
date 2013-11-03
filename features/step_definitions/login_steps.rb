Given(/^I'm logged in$/) do
  visit send("new_#{@user_type}_session_path")
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: @user.password
  click_on "Prijava"
end

When(/^I log in$/) do
  ensure_on send("new_#{@user_type}_session_path")
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
  expect(current_path).to eq path_to("homepage")
end

Then(/^I should be logged out$/) do
  expect(current_path).to eq root_path
end
