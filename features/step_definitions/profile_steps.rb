When(/^I confirm my password$/) do
  fill_in "Lozinka", with: @user.password
  click_on "Potvrdi"
end
