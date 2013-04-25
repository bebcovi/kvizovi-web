require "nokogiri"

When(/^I request for a new password$/) do
  click_on "Zatražite novu"
  fill_in "Email", with: Factory.attributes_for(@user_type)[:email]
  click_on "Zatraži novu lozinku"
end

When(/^I login with the emailed password$/) do
  emailed_password = Nokogiri::HTML(PasswordSender.deliveries.first.body.to_s).at("strong").text
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: emailed_password
  click_on "Prijava"
end

Then(/^I should get the email with my new password$/) do
  expect(ActionMailer::Base.deliveries).to have(1).item
  expect(ActionMailer::Base.deliveries.first.body.to_s).to have_content("lozinka")
end
