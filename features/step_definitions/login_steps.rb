Given(/^I'm logged in$/) do
  page.cookies.signed.permanent[:user_id] = @user.id
  page.cookies.signed.permanent[:user_type] = @user.type
end

When(/^I log in$/) do
  ensure_on login_url
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
  expect(current_url).to eq url_to("homepage")
end

Then(/^I should be logged out$/) do
  expect(current_url).to eq root_url(subdomain: false)
end
