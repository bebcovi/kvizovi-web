require "spec_helper"

feature "Profile" do
  let!(:school) { register(:school) }

  background do
    login(school)
  end

  scenario "Changing info" do
    click_on "Uredi profil"
    click_on "Izmijeni profil"

    submit

    expect(page).to have_content("Izmijeni profil")
  end

  scenario "Changing password" do
    click_on "Uredi profil"
    click_on "Izmijeni lozinku"

    fill_in "Trenutna lozinka",     with: school.password
    fill_in "Nova lozinka",         with: "secret"
    fill_in "Potvrda nove lozinke", with: "secret"
    submit

    expect(page).to have_css(".alert-success")
  end

  scenario "Deleting account" do
    click_on "Uredi profil"
    click_on "Izbriši korisnički račun"

    expect(page).to have_css(".alert")
    expect(school).to be_logged_out
  end
end
