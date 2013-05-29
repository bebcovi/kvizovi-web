require "uri"
require "nokogiri"

Given(/^I forgot my password$/) do
end

When(/^I request a new password$/) do
  ensure_on login_url(subdomain: @user.type)
  click_on "Zatražite novu"
  school do
    fill_in "Email", with: @user.email
  end
  student do
    fill_in "Korisničko ime", with: @user.username
    fill_in "Email",          with: "student@example.com"
  end
  click_on "Zatraži novu lozinku"
end

When(/^(?:I|my school) visit(?:s)? the confirmation URL$/) do
  confirmation_url = URI.extract(ActionMailer::Base.deliveries.last.body.to_s, ["http"]).first
  visit confirmation_url
end

Then(/^(?:I|my school) should get an email with the confirmation for resetting my password$/) do
  expect(ActionMailer::Base.deliveries).to have(1).item
  school  { expect(ActionMailer::Base.deliveries.last.to).to include(@user.email) }
  student { expect(ActionMailer::Base.deliveries.last.to).to include(@user.school.email) }
  expect(ActionMailer::Base.deliveries.last.body.to_s).to match(uri_regexp)
end

Then(/^I should get an email with my new password$/) do
  expect(ActionMailer::Base.deliveries).to have(2).items
  school  { expect(ActionMailer::Base.deliveries.last.to).to include(@user.email) }
  student { expect(ActionMailer::Base.deliveries.last.to).to include("student@example.com") }
  expect(ActionMailer::Base.deliveries.last.body.to_s).to match(/lozinka/i)
end

Then(/^I should be able to login with that password$/) do
  new_password = Nokogiri::HTML(ActionMailer::Base.deliveries.last.body.to_s).at("strong").text
  ensure_on login_url(subdomain: @user.type)
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: new_password
  click_on "Prijava"
  expect(current_path).to be_in [quizzes_path, choose_quiz_path]
end

Then(/^my school should get an email with the confirmation for resetting my password$/) do
  expect(ActionMailer::Base.deliveries).to have(1).item
  expect(ActionMailer::Base.deliveries.last.to).to include(@user.school.email)
  expect(ActionMailer::Base.deliveries.last.body.to_s).to match(uri_regexp)
end

def uri_regexp
  /http:\/\/[^\s]+/
end
