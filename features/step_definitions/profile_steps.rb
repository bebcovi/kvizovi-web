When(/^I update my profile$/) do
  fill_in "Ime", with: "New name"
  click_on "Spremi"
end

When(/^I update my password$/) do
  fill_in "Stara lozinka",        with: @user.password
  fill_in "Nova lozinka",         with: "new password"
  fill_in "Potvrda nove lozinke", with: "new password"
  click_on "Spremi"
end

When(/^I log in again with the updated password$/) do
  click_on "Odjava"
  visit login_url
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: "new password"
  click_on "Prijava"
end

When(/^I confirm my password$/) do
  fill_in "Lozinka", with: @user.password
  click_on "Potvrdi"
end

Then(/^I should see my updated profile$/) do
  expect(page).to have_content("New name")
end
