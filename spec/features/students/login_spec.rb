require "spec_helper"

feature "Login" do
  before do
    @student = create(:student, :with_school)
  end

  scenario "A student can login" do
    visit root_path
    click_on "Ja sam učenik"

    fill_in "Korisničko ime", with: @student.username
    fill_in "Lozinka",        with: @student.password
    check "Zapamti me"
    click_on "Prijava"

    expect(current_path).to eq new_game_path
  end
end
