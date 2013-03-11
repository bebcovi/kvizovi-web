require "spec_helper"
require "nokogiri"

feature "School" do
  before { @school = create(:school) }

  scenario "resetting password" do
    visit login_path(type: "school")
    click_on "Zatražite novu"
    fill_in "email", with: @school.email
    expect { click_on "Zatraži novu lozinku" }.to change{@school.reload.password_digest}

    expect(current_path).to eq login_path
    page.should have_css(".alert-success")
    @school.password_digest.should be_present

    expect(PasswordResetNotifier.deliveries).to have(1).item
    sent_email = PasswordResetNotifier.deliveries.first.body.to_s
    new_password = Nokogiri::HTML(sent_email).at("strong").text

    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka", with: new_password
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
    expect(page).to have_content(@school.username)
  end

  scenario "changing password" do
    login_as(@school)

    visit school_path(@school)
    click_on "Izmjeni lozinku"

    # unsuccessful
    click_on "Spremi"

    expect(page).to have_css(".error")

    # successful
    fill_in "Stara lozinka", with: @school.password
    fill_in "Nova lozinka", with: "new password"
    fill_in "Potvrda nove lozinke", with: "new password"
    click_on "Spremi"

    logout
    visit login_path(type: "school")
    fill_in "Korisničko ime", with: @school.username
    fill_in "Lozinka", with: "new password"
    click_on "Prijava"

    expect(current_path).to eq quizzes_path
    expect(page).to have_content(@school.username)
  end
end
