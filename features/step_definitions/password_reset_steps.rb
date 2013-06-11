require "uri"
require "nokogiri"

Given(/^I didn't provide my email during registration$/) do
  @user.update_column(:email, nil)
end

Given(/^I have forgot my password$/) do
end

When(/^I request a new password$/) do
  ensure_on login_url
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

Then(/^I should get an email with the confirmation for resetting my password$/) do
  expect(ActionMailer::Base.deliveries).to have(1).item
  expect(ActionMailer::Base.deliveries.last.to).to include(@user.email)
  expect(ActionMailer::Base.deliveries.last.body.to_s).to match(/http:\/\/[^\s]+/)
end

Then(/^I should get an email with my new password$/) do
  expect(ActionMailer::Base.deliveries).to have(2).items
  expect(ActionMailer::Base.deliveries.last.to).to include(@user.email)
  expect(ActionMailer::Base.deliveries.last.body.to_s).to match(/lozinka/i)
end

Then(/^I should be able to login with that password$/) do
  new_password = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.to_s).at("strong").text
  ensure_on login_url
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: new_password
  click_on "Prijava"
  expect(current_url).to eq url_to("homepage")
end

Then(/^I should be given a text field for putting my email$/) do
  expect(page).to have_css("input##{@user.type}_email")
end

Then(/^I should not see the text field anymore$/) do
  expect(page).not_to have_css("input##{@user.type}_email")
end
