require "nokogiri"

When(/^I confirm my email$/) do
  user = FactoryGirl.build(@user_type)
  fill_in "Email", with: user.email
  click_on "Zatraži novu lozinku"
end

When(/^I fill in "(.*)" with the emailed password$/) do |field|
  new_password = Nokogiri::HTML(PasswordSender.deliveries.first.body.to_s).at("strong").text
  fill_in field, with: new_password
end
