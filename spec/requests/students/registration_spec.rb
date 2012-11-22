# encoding: utf-8
require "spec_helper_full"

describe "Registering student" do
  before(:all) { @school = create(:school) }

  let(:attributes) { attributes_for(:student) }

  it "has the link for it on the login page" do
    visit login_path(type: "student")
    click_on "Registriraj se"
    current_path.should eq new_student_path
  end

  it "stays on the same page on validation errors" do
    visit new_student_path
    expect { click_on "Registriraj se" }.to_not change{Student.count}
    current_path.should eq students_path
  end

  it "logs in the student, and redirects to the new game" do
    visit new_student_path

    fill_in "Ime", with: attributes[:first_name]
    fill_in "Prezime", with: attributes[:last_name]
    choose attributes[:gender]
    select attributes[:year_of_birth].to_s, from: "Godina rođenja"
    fill_in "Korisničko ime", with: attributes[:username]
    fill_in "Lozinka", with: attributes[:password]
    fill_in "Potvrda lozinke", with: attributes[:password]
    fill_in "Razred", with: attributes[:grade]
    fill_in "Tajni ključ škole", with: @school.key

    expect { click_on "Registriraj se" }.to change{Student.count}.by 1

    current_path.should eq new_game_path
    page.should have_content(attributes[:first_name])
  end
end
