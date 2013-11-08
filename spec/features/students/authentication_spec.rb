require "spec_helper"
require "uri"

feature "Authentication" do
  scenario "Login & Logout" do
    student = register(:student)
    visit root_path
    click_on "Ja sam učenik"

    fill_in "Korisničko ime", with: student.username
    fill_in "Lozinka",        with: student.password
    submit

    expect(student).to be_logged_in

    click_on "Odjava"

    expect(student).to be_logged_out
  end

  scenario "Registration" do
    school = register(:school)
    visit new_student_session_path
    click_on "Registrirajte se"

    fill_in      "Ime",               with: "Janko"
    fill_in      "Prezime",           with: "Marohnić"
    choose_under "Spol",                    "Muško"
    select_from  "Godina rođenja",          "1991"
    fill_in      "Korisničko ime",    with: "junky"
    fill_in      "Lozinka",           with: "secret"
    fill_in      "Potvrda lozinke",   with: "secret"
    fill_in      "Email",             with: "janko@janko.hr"
    fill_in      "Razred",            with: "4.e"
    fill_in      "Tajni ključ škole", with: school.key
    submit

    student = get_user(Student.last)
    expect(student).to be_logged_in

    expect(sent_emails.last.to).to include(student.email)
    expect(sent_emails.last.subject).to include("Potvrda korisničkog računa")

    confirmation_url = URI.extract(sent_emails.last.body.to_s, ["http"]).first
    visit confirmation_url

    expect(page).to have_css(".alert-success")
  end

  scenario "Password reset" do
    student = register(:student)
    visit new_student_session_path
    click_on "Zatražite novu"

    fill_in "Email", with: student.email
    submit

    expect(sent_emails.last.to).to include(student.email)
    expect(sent_emails.last.subject).to include("Potvrda za promjenu lozinke")

    confirmation_url = URI.extract(sent_emails.last.body.to_s, ["http"]).first
    visit confirmation_url

    fill_in "Nova lozinka",         with: "nova lozinka"
    fill_in "Potvrda nove lozinke", with: "nova lozinka"
    submit

    expect(student).to be_logged_in
  end

  scenario "Email requirement" do
    student = register(:student, school: create(:school))
    student.update_column(:email, nil)
    login(student)

    expect(current_path).to eq edit_account_profile_path
    expect(page).to have_css(".alert-warning")

    fill_in "Email", with: "janko@janko.hr"
    submit

    visit account_path
    expect(current_path).to eq account_path
  end
end
