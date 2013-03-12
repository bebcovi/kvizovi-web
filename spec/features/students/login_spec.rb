require "spec_helper"

feature "Students" do
  before { @student = create(:student, :with_school) }

  scenario "login" do
    visit root_path
    click_on "Ja sam učenik"

    # unsuccessful
    click_on "Prijava"

    expect(page).to have_css(".alert-error")

    # sucessful
    fill_in "Korisničko ime", with: @student.username
    fill_in "Lozinka",        with: @student.password
    click_on "Prijava"

    expect(current_path).to eq new_game_path
    expect(page).to have_content(@student.username)
  end

  scenario "login with remebering" do
    visit root_path
    click_on "Ja sam učenik"

    fill_in "Korisničko ime", with: @student.username
    fill_in "Lozinka",        with: @student.password
    check "Zapamti me"
    click_on "Prijava"

    expect(current_path).to eq new_game_path
    expect(page).to have_content(@student.username)
  end
end
