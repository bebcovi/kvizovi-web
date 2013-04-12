When(/^I visit (.*)$/) do |page|
  visit path_to(page)
end

When(/^I go to (.*)$/) do |page|
  visit path_to(page)
end

When(/^I click on "(.*)"$/) do |text|
  click_on text
end

When(/^I fill in "(.*)" with "(.*)"$/) do |field, value|
  fill_in field, with: value
end

When(/^I check "(.*)"/) do |text|
  check text
end

When(/^I choose "(.*)"/) do |text|
  choose text
end

Then(/^I should be on (.*)$/) do |page|
  expect(current_url).to eq path_to(page)
end

Then(/^I should see "(.*)"$/) do |content|
  expect(page).to have_content(content)
end

Then(/^I should not see "(.*)"$/) do |content|
  expect(page).not_to have_content(content)
end
