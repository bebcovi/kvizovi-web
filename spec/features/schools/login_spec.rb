require "spec_helper"

feature "Login" do
  before do
    @school = create(:school)
  end

  scenario "A school can login, and gets redirected to quizzes" do
    visit root_path
    click_on "Ja sam škola"

    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka",        with: @school.password
    check "Zapamti me"
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
  end
end
