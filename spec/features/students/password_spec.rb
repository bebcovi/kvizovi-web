require "spec_helper"

feature "Students" do
  before { @student = create(:student, :with_school) }

  scenario "changing password" do
    login_as(@student)

    visit student_path(@student)
    click_on "Izmjeni lozinku"

    # unsuccessful
    click_on "Spremi"

    expect(page).to have_css(".error")

    # successful
    fill_in "Stara lozinka", with: @student.password
    fill_in "Nova lozinka", with: "new password"
    fill_in "Potvrda nove lozinke", with: "new password"
    click_on "Spremi"

    logout
    visit login_path(type: "student")
    fill_in "Korisničko ime", with: @student.username
    fill_in "Lozinka", with: "new password"
    click_on "Prijava"

    expect(current_path).to eq new_game_path
    expect(page).to have_content(@student.username)
  end
end
