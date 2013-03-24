require "spec_helper"

feature "Profile" do
  before do
    @student = create(:student, :with_school)
  end

  scenario "A school can edit its profile" do
    login_as(@student)
    click_on "Uredi profil"

    click_on "Izmijeni profil"
    click_on "Spremi"

    expect(current_path).to eq profile_path
  end

  scenario "A student can update his password" do
    login_as(@student)
    click_on "Uredi profil"
    click_on "Izmijeni lozinku"

    fill_in "Stara lozinka",        with: @student.password
    fill_in "Nova lozinka",         with: "new password"
    fill_in "Potvrda nove lozinke", with: "new password"
    click_on "Spremi"

    logout
    click_on "Ja sam učenik"

    fill_in "Korisničko ime", with: @student.username
    fill_in "Lozinka",        with: "new password"
    click_on "Prijava"

    expect(current_path).to eq new_game_path
  end

  scenario "A student can delete its account" do
    login_as(@student)
    click_on "Uredi profil"
    click_on "Izbriši korisnički račun"

    fill_in "Lozinka", with: @student.password
    click_on "Potvrdi"

    expect(current_path).to eq root_path
    expect(Student.exists?(@student)).to be_false
  end
end
