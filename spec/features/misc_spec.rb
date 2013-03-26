require "spec_helper"

feature "Miscellaneous" do
  scenario "Upon authentication, the user is redirected to the page which he originally requested" do
    school = create(:school)

    visit profile_url(subdomain: "school")

    fill_in "Korisničko ime", with: school.username
    fill_in "Lozinka",        with: school.password
    click_on "Prijava"

    expect(current_path).to eq profile_path
  end
end
