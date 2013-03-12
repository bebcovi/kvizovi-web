require "spec_helper"

feature "Students" do
  before {
    @student = build(:student)
    @school = create(:school)
  }

  scenario "registration" do
    visit root_path
    click_on "Ja sam učenik"
    click_on "Registriraj se"

    # unsuccessful registration
    click_on "Registriraj se"

    expect(page).to have_css(".error")

    # successful registration
    fill_in "Ime",               with: @student.first_name
    fill_in "Prezime",           with: @student.last_name
    fill_in "Korisničko ime",    with: @student.username
    fill_in "Lozinka",           with: @student.password
    fill_in "Potvrda lozinke",   with: @student.password
    fill_in "Razred",            with: @student.grade
    fill_in "Tajni ključ škole", with: @school.key
    choose @student.gender
    select @student.year_of_birth.to_s, from: "Godina rođenja"
    click_on "Registriraj se"

    expect(current_path).to eq new_game_path
    expect(page).to have_content(@student.username)
    expect(Student.first.reload.school).to eq @school
  end
end
