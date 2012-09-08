# encoding: utf-8
require "spec_helper"

describe "Registration" do
  context "of schools" do
    it "works as expected" do
      # Needs authorization
      visit school_login_path
      all("p").last.find("a").click
      page.current_path.should eq(authorize_path)

      fill_in "Tajni ključ aplikacije", with: "foo"
      click_on "Potvrdi"
      page.should have_content("Ključ je netočan.")

      page.current_path.should eq(authorize_path)
      find_field("Tajni ključ aplikacije").value.should be_nil
      fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
      click_on "Potvrdi"
      page.should have_content("Točno ste napisali ključ.")

      # Registration
      page.current_path.should eq(new_school_path)
      school = build_stubbed(:school)
      fill_in "Ime škole", with: school.name
      select school.level, from: "Tip škole"
      fill_in "Korisničko ime", with: school.username
      fill_in "Lozinka", with: school.password
      fill_in "Potvrda lozinke", with: "wrong"
      fill_in "Tajni ključ", with: school.key
      click_on "Registriraj se"

      page.current_path.should eq(schools_path)
      find_field("Ime škole").value.should_not be_nil
      find_field("Korisničko ime").value.should_not be_nil
      find_field("Lozinka").value.should be_nil
      find_field("Potvrda lozinke").value.should be_nil
      find_field("Tajni ključ").value.should be_nil

      fill_in "Lozinka", with: school.password
      fill_in "Potvrda lozinke", with: school.password
      fill_in "Tajni ključ", with: school.key
      click_on "Registriraj se"

      page.current_path.should eq(school_path(School.first))
      find("#log").should have_link(school.name)
    end
  end

  context "of students" do
    it "works as expected" do
      # It has a direct link
      visit student_login_path
      all("p").last.find("a").click
      page.current_path.should eq(new_student_path)

      # Registration
      student = build_stubbed(:student)
      fill_in "Ime", with: student.first_name
      fill_in "Prezime", with: student.last_name
      fill_in "Korisničko ime", with: student.username
      fill_in "Lozinka", with: student.password
      fill_in "Potvrda lozinke", with: "wrong"
      select ordinalize(student.grade), from: "Razred"
      fill_in "Tajni ključ škole", with: student.school.key
      click_on "Registriraj se"

      page.current_path.should eq(students_path)
      find_field("Ime").value.should_not be_nil
      find_field("Prezime").value.should_not be_nil
      find_field("Korisničko ime").value.should_not be_nil
      find_field("Lozinka").value.should be_nil
      find_field("Potvrda lozinke").value.should be_nil
      find_field("Tajni ključ škole").value.should_not be_nil

      fill_in "Lozinka", with: student.password
      fill_in "Potvrda lozinke", with: student.password
      click_on "Registriraj se"

      page.current_path.should eq(new_game_path)
      find("#log").should have_link(student.full_name)
    end
  end

end
