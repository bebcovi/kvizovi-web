Given(/^I'm on the (.*)$/) do |page|
  ensure_on path_to(page)
end

When(/^I visit (.*)$/) do |page|
  visit path_to(page)
end

When(/^I go to (.*)$/) do |page|
  visit path_to(page)
end

When(/^I click on "(.*)"$/) do |text|
  click_on text
end

Then(/^I should (?:still )?be on (.*)$/) do |page|
  expect(current_url).to eq path_to(page)
end

Then(/^I should see "(.*)"$/) do |content|
  expect(page).to have_content(content)
end

Then(/^I should not see "(.*)"$/) do |content|
  expect(page).not_to have_content(content)
end
