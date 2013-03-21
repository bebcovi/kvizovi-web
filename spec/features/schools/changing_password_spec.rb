require "spec_helper"
require "nokogiri"

feature "Changing password" do
  before do
    @school = create(:school)
  end

  scenario "A school can reset its password" do
    visit root_path
    click_on "Ja sam škola"
    click_on "Zatražite novu"

    fill_in "email", with: @school.email
    click_on "Zatraži novu lozinku"

    new_password = Nokogiri::HTML(PasswordResetNotifier.deliveries.first.body.to_s).at("strong").text

    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka",        with: new_password
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
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
end
