require "spec_helper"

feature "School" do
  before { @school = build(:school) }

  scenario "registration" do
    visit root_path
    click_on "Ja sam škola"
    click_on "Registrirajte se"
    expect(current_path).to eq authorize_path

    # unsuccessful authorization
    click_on "Potvrdi"

    # successful authorization
    fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
    click_on "Potvrdi"
    expect(current_path).to eq new_school_path

    # unsuccessful registration
    click_on "Registriraj se"

    expect(page).to have_css(".error")

    # successful registration
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

    expect(current_path).to eq quizzes_path
    expect(page).to have_content(@school.username)
    expect(page).to have_content("Antigona")
  end
end
