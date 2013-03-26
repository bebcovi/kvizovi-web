require "spec_helper"

feature "Registration" do
  before do
    @student = build(:student, :with_school)
  end

  scenario "A student can register" do
    visit root_path
    click_on "Ja sam učenik"
    click_on "Registriraj se"

    fill_in "Ime",               with: @student.first_name
    fill_in "Prezime",           with: @student.last_name
    fill_in "Korisničko ime",    with: @student.username
    fill_in "Lozinka",           with: @student.password
    fill_in "Potvrda lozinke",   with: @student.password
    fill_in "Razred",            with: @student.grade
    fill_in "Tajni ključ škole", with: @student.school.key
    choose @student.gender
    select @student.year_of_birth.to_s, from: "Godina rođenja"
    click_on "Registriraj se"

    expect(current_path).not_to eq registrations_path
  end
end
