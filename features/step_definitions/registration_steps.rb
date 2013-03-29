Given(/^I'm registered$/) do
  school  { @user = FactoryGirl.create(:school) }
  student { @user = FactoryGirl.create(:student, :with_school) }
end

Given(/^I'm registered with username "(.*?)" and password "(.*?)"$/) do |username, password|
  school  { @user = FactoryGirl.create(:school,                username: username, password: password) }
  student { @user = FactoryGirl.create(:student, :with_school, username: username, password: password) }
end

Given(/^my school is registered$/) do
  FactoryGirl.create(:school)
end

When(/^I authorize$/) do
  fill_in "Tajni ključ aplikacije", with: ENV["SECRET_KEY"]
  click_on "Potvrdi"
end

When(/^I fill in the registration details$/) do
  user = FactoryGirl.build(@user_type)
  school do
    fill_in "Ime škole",       with: user.name
    fill_in "Mjesto",          with: user.place
    fill_in "Korisničko ime",  with: user.username
    fill_in "Lozinka",         with: user.password
    fill_in "Potvrda lozinke", with: user.password
    fill_in "Email",           with: user.email
    fill_in "Tajni ključ",     with: user.key
    select                           user.level,  from: "Tip škole"
    select                           user.region, from: "Županija"
  end
  student do
    fill_in "Ime",               with: user.first_name
    fill_in "Prezime",           with: user.last_name
    fill_in "Korisničko ime",    with: user.username
    fill_in "Lozinka",           with: user.password
    fill_in "Potvrda lozinke",   with: user.password
    fill_in "Razred",            with: user.grade
    fill_in "Tajni ključ škole", with: School.first.key
    choose                             user.gender
    select                             user.year_of_birth.to_s, from: "Godina rođenja"
  end
end

Then(/^I should not be registered/) do
  expect(@user.class.exists?(@user)).to be_false
end
