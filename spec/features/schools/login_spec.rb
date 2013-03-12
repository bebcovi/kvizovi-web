require "spec_helper"

feature "Schools" do
  before { @school = create(:school) }

  scenario "login" do
    visit root_path
    click_on "Ja sam škola"

    # unsuccessful
    click_on "Prijava"

    expect(page).to have_css(".alert-error")

    # sucessful
    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka",        with: @school.password
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
    expect(page).to have_content(@school.username)
  end

  scenario "login with remebering" do
    visit root_path
    click_on "Ja sam škola"

    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka",        with: @school.password
    check "Zapamti me"
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
    expect(page).to have_content(@school.username)
  end
end
