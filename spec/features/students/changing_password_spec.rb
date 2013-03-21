require "spec_helper"

feature "Changing password" do
  before do
    @student = create(:student, :with_school)
  end

  scenario "A student can update his password" do
    login_as(@student)
    click_on "Uredi profil"
    click_on "Izmjeni lozinku"

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
end
