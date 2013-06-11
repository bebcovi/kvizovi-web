require "timecop"

Given(/^a user is registered and had some activity on the site$/) do
  @user = FactoryGirl.create(:school)
  Timecop.freeze(30.minutes.ago) { browse_site }
end

When(/^the user browses the site some more/) do
  Timecop.freeze(15.minutes.ago) { browse_site }
end

Then(/^I should see the time of his last activity$/) do
  expect(page).to have_content("prije 30 minuta")
end

Then(/^the time of his last activity should change$/) do
  visit admin_schools_url
  expect(page).to have_content("prije 15 minuta")
end

def browse_site
  step "I log in"
  step "I log out"
end
