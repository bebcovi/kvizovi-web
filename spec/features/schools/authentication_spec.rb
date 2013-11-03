require "spec_helper"
require "uri"

feature "Authentication" do
  scenario "Login & Logout" do
    school = register(:school)
    visit root_path
    click_on "Ja sam škola"

    fill_in "Korisničko ime", with: school.username
    fill_in "Lozinka",        with: school.password
    submit

    expect(school).to be_logged_in

    click_on "Odjava"

    expect(school).to be_logged_out
  end

  scenario "Registration" do
    visit new_school_session_path
    click_on "Registrirajte se"

    fill_in      "Ime škole",       with: "XV. Gimnazija"
    choose_under "Tip škole",             "Srednja"
    fill_in      "Mjesto",          with: "Jordanovac 5"
    select_from  "Županija",              "Grad Zagreb"
    fill_in      "Email",           with: "mioc@mioc.hr"
    fill_in      "Korisničko ime",  with: "mioc"
    fill_in      "Lozinka",         with: "secret"
    fill_in      "Potvrda lozinke", with: "secret"
    fill_in      "Tajni ključ",     with: "mioc"
    submit

    school = get_user(School.last)
    expect(school).to be_logged_in

    expect(sent_emails.last.to).to include(school.email)
    expect(sent_emails.last.subject).to include("Potvrda korisničkog računa")

    confirmation_url = URI.extract(sent_emails.last.body.to_s, ["http"]).first
    visit confirmation_url

    expect(page).to have_css(".alert-success")
  end

  scenario "Password reset" do
    school = register(:school)
    visit new_school_session_path
    click_on "Zatražite novu"

    fill_in "Email", with: school.email
    submit

    expect(sent_emails.last.to).to include(school.email)
    expect(sent_emails.last.subject).to include("Potvrda za promjenu lozinke")

    confirmation_url = URI.extract(sent_emails.last.body.to_s, ["http"]).first
    visit confirmation_url

    fill_in "Nova lozinka",         with: "nova lozinka"
    fill_in "Potvrda nove lozinke", with: "nova lozinka"
    submit

    expect(school).to be_logged_in
  end
end
