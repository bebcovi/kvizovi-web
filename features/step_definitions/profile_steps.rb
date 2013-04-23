When(/^I update my name$/) do
  fill_in "Ime", with: "New name"
  click_on "Spremi"
end

When(/^I update my password$/) do
  fill_in "Stara lozinka",        with: @user.password
  fill_in "Nova lozinka",         with: "new password"
  fill_in "Potvrda nove lozinke", with: "new password"
  click_on "Spremi"
end

When(/^I fill in my login information with the updated password$/) do
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: "new password"
end

When(/^I confirm my password$/) do
  fill_in "Lozinka", with: @user.password
  click_on "Potvrdi"
end

Then(/^I should see my new name$/) do
  expect(page).to have_content("New name")
end
