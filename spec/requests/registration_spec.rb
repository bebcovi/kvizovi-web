# encoding: utf-8
require "spec_helper_full"

describe "Registration" do
  context "of schools" do
    def authorize
      visit authorize_path
      fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
      click_on "Potvrdi"
    end

    def fill_in_the_form
      fill_in "Ime škole", with: school.name
      select school.level, from: "Tip škole"
      fill_in "Mjesto", with: school.place
      select school.region, from: "Županija"
      fill_in "Korisničko ime", with: school.username
      fill_in "Lozinka", with: school.password
      fill_in "Email", with: school.email
      fill_in "Potvrda lozinke", with: school.password
      fill_in "Tajni ključ", with: school.key
    end

    let(:school) { build_stubbed(:school) }

    it "has the link in the login page" do
      visit school_login_path
      find_link("ovdje")[:href].should eq(new_school_path)
    end

    it "requires authorization" do
      visit new_school_path
      current_path.should eq(authorize_path)

      fill_in "Tajni ključ aplikacije", with: "foo"
      click_on "Potvrdi"
      page.should have_content("Ključ je netočan.")

      current_path.should eq(authorize_path)
      find_field("Tajni ključ aplikacije").value.should be_nil
      fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
      click_on "Potvrdi"

      page.should have_content("Točno ste napisali ključ.")
    end

    it "keeps the fields filled in upon validation errors" do
      authorize

      current_path.should eq(new_school_path)
      fill_in_the_form
      fill_in "Potvrda lozinke", with: "wrong"
      click_on "Registriraj se"

      current_path.should eq(schools_path)
      find_field("Ime škole").value.should_not be_nil
      find("option[value=#{school.level}]").should be_selected
      find_field("Mjesto").value.should_not be_nil
      find("option[value=\"#{school.region}\"]").should be_selected
      find_field("Korisničko ime").value.should_not be_nil
      find_field("Lozinka").value.should be_nil
      find_field("Potvrda lozinke").value.should be_nil
      find_field("Tajni ključ").value.should be_nil
    end

    it "redirects to school on success and it creates an example quiz" do
      authorize

      fill_in_the_form
      expect { click_on "Registriraj se" }.to change{School.count}.from(0).to(1)

      School.first.quizzes.should_not be_empty
      find("#log").should have_link(school.name)
    end

    after(:all) do
      School.destroy_all
    end
  end

  context "of students" do
    before(:each) do
      School.stub(:find_by_key) { school }
      Student.stub(:find) { student }
    end

    let(:school) { build_stubbed(:school) }
    let(:student) do
      build_stubbed(:student).tap do |student|
        student.stub(:school) { school }
      end
    end

    def fill_in_the_form
      fill_in "Ime", with: student.first_name
      fill_in "Prezime", with: student.last_name
      choose student.gender
      select student.year_of_birth.to_s, from: "Godina rođenja"
      fill_in "Korisničko ime", with: student.username
      fill_in "Lozinka", with: student.password
      fill_in "Potvrda lozinke", with: student.password
      fill_in "Razred", with: student.grade
      fill_in "Tajni ključ škole", with: student.school.key
    end

    it "has the link on the login page" do
      visit student_login_path
      find_link("ovdje")[:href].should eq(new_student_path)
    end

    it "keeps the fields filled in upon validation errors" do
      visit new_student_path
      current_path.should eq(new_student_path)

      fill_in_the_form
      fill_in "Potvrda lozinke", with: "wrong"
      click_on "Registriraj se"

      current_path.should eq(students_path)
      find_field("Ime").value.should_not be_nil
      find_field("Prezime").value.should_not be_nil
      find_field(student.gender).should be_checked
      find("option[value=\"#{student.year_of_birth}\"]").should be_selected
      find_field("Korisničko ime").value.should_not be_nil
      find_field("Lozinka").value.should be_nil
      find_field("Potvrda lozinke").value.should be_nil
      find_field("Razred").value.should_not be_nil
      find_field("Tajni ključ škole").value.should_not be_nil
    end

    it "redirects to new game on success" do
      visit new_student_path

      fill_in_the_form
      expect { click_on "Registriraj se" }.to change{Student.count}.by(1)

      current_path.should eq(new_game_path)
      find("#log").should have_link(student.first_name)
    end

    after(:all) do
      Student.destroy_all
    end
  end
end
