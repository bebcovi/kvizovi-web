Given(/^I'm on (?:the|my) (.*)$/) do |page|
  ensure_on url_to(page)
end

When(/^I visit (.*)$/) do |page|
  visit url_to(page)
end

When(/^I go to (.*)$/) do |page|
  visit url_to(page)
end

When(/^I click on "(.*)"$/) do |text|
  click_on text
end

Then(/^I should (?:still )?be on (.*)$/) do |page|
  expect(current_url).to eq url_to(page)
end

Then(/^I should( not)? see "(.*)"$/) do |negative, content|
  if not negative
    expect(page).to have_content(content)
  else
    expect(page).not_to have_content(content)
  end
end

Then(/^I should( not)? see link "(.*)"$/) do |negative, content|
  if not negative
    expect(page).to have_link(content)
  else
    expect(page).not_to have_link(content)
  end
end
