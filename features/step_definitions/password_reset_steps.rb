require "uri"
require "nokogiri"

Given(/^I didn't provide my email during registration$/) do
  @user.update_column(:email, nil)
end

Given(/^I have forgot my password$/) do
end

When(/^I request a new password$/) do
  ensure_on send("new_#{@user_type}_session_path")
  click_on "Zatražite novu"
  fill_in "Email", with: @user.email
  click_on "Zatraži novu lozinku"
end

When(/^I visit the confirmation URL$/) do
  confirmation_url = URI.extract(ActionMailer::Base.deliveries.last.body.to_s, ["http"]).first
  visit confirmation_url
end

When(/^I fill in my email$/) do
  fill_in "Email", with: "jon.snow@example.com"
end

When(/^I fill in a new password/) do
  fill_in "Nova lozinka",         with: "secret"
  fill_in "Potvrda nove lozinke", with: "secret"
end

Then(/^I should get an email with the confirmation for resetting my password$/) do
  expect(ActionMailer::Base.deliveries).to have(1).item
  expect(ActionMailer::Base.deliveries.last.to).to include(@user.email)
end

Then(/^I should be given an email field$/) do
  expect(page).to have_css("input##{@user.type}_email")
end

Then(/^I should not see the email field anymore$/) do
  expect(page).not_to have_css("input##{@user.type}_email")
end
