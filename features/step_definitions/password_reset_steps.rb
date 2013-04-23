require "nokogiri"

When(/^I confirm my email$/) do
  fill_in "Email", with: Factory.attributes_for(@user_type)[:email]
  click_on "Zatraži novu lozinku"
end

When(/^I fill in my login information with the emailed password$/) do
  emailed_password = Nokogiri::HTML(PasswordSender.deliveries.first.body.to_s).at("strong").text
  fill_in "Korisničko ime", with: @user.username
  fill_in "Lozinka",        with: emailed_password
end
