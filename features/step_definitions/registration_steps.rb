Given(/^I'm registered( as an admin)?$/) do |admin|
  @user = FactoryGirl.create(@user_type)
  @user.update_column(:admin, true) if admin
end

Given(/^my school is registered$/) do
  @school = FactoryGirl.create(:school)
end

Given(/^there is another school registered$/) do
  @other_school = FactoryGirl.create(:school)
end

Given(/^I'm registered and logged in( as an admin)?$/) do |admin|
  steps %Q{
    Given I'm registered#{admin}
    And I'm logged in
  }
end

When(/^I go to the registration page$/) do
  visit send("new_#{@user_type}_session_path")
  click_on "Registrirajte se"
end

When(/^I fill in the registration details$/) do
  if school?
    school = FactoryGirl.build(:school)
    fill_in "Ime škole",       with: school.name
    fill_in "Mjesto",          with: school.place
    fill_in "Korisničko ime",  with: school.username
    fill_in "Lozinka",         with: school.password
    fill_in "Potvrda lozinke", with: school.password
    fill_in "Email",           with: school.email
    fill_in "Tajni ključ",     with: school.key
    select                           school.level,  from: "Tip škole"
    select                           school.region, from: "Županija"
  else
    student = FactoryGirl.build(:student, school: @school)
    fill_in "Ime",               with: student.first_name
    fill_in "Prezime",           with: student.last_name
    fill_in "Korisničko ime",    with: student.username
    fill_in "Lozinka",           with: student.password
    fill_in "Potvrda lozinke",   with: student.password
    fill_in "Email",             with: student.email
    fill_in "Razred",            with: student.grade
    fill_in "Tajni ključ škole", with: student.school.key
    choose                             student.gender
    select                             student.year_of_birth.to_s, from: "Godina rođenja"
  end
end

Then(/^I should not be registered/) do
  expect(@user.class.exists?(@user)).to be_false
end
