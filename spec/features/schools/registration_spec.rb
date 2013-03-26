require "spec_helper"

feature "Registration" do
  before do
    @school = build(:school)
  end

  scenario "A school can register" do
    visit root_path
    click_on "Ja sam škola"
    click_on "Registrirajte se"

    fill_in "Tajni ključ aplikacije", with: ENV["SECRET_KEY"]
    click_on "Potvrdi"

    fill_in "Ime škole",       with: @school.name
    fill_in "Mjesto",          with: @school.place
    fill_in "Korisničko ime",  with: @school.username
    fill_in "Lozinka",         with: @school.password
    fill_in "Potvrda lozinke", with: @school.password
    fill_in "Email",           with: @school.email
    fill_in "Tajni ključ",     with: @school.key
    select @school.level,  from: "Tip škole"
    select @school.region, from: "Županija"
    click_on "Registriraj se"

    expect(current_path).not_to eq registrations_path
  end
end
