require "spec_helper"

feature "Profile" do
  before do
    @school = create(:school)
  end

  scenario "A school can edit its profile" do
    login_as(@school)
    click_on "Uredi profil"

    click_on "Izmjeni profil"
    click_on "Spremi"

    expect(current_path).to eq profile_path
  end

  scenario "A school can update its password" do
    login_as(@school)
    click_on "Uredi profil"
    click_on "Izmjeni lozinku"

    fill_in "Stara lozinka",        with: @school.password
    fill_in "Nova lozinka",         with: "new password"
    fill_in "Potvrda nove lozinke", with: "new password"
    click_on "Spremi"

    logout
    click_on "Ja sam škola"

    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka",        with: "new password"
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
  end

  scenario "A school can delete its account" do
    login_as(@school)
    click_on "Uredi profil"
    click_on "Izbriši korisnički račun"

    fill_in "Lozinka", with: @school.password
    click_on "Potvrdi"

    expect(current_path).to eq root_path
    expect(School.exists?(@student)).to be_false
  end
end
