# encoding: utf-8
require "spec_helper_full"

describe "Student" do
  before(:all) do
    @school = create(:school)
    @student = create(:student, school: @school)
  end
  before(:each) { login(:student, attributes_for(:student)) }

  context "when updating profile" do
    it "has a link on the account page" do
      visit student_path(@student)
      click_on "Izmjeni profil"
      current_path.should eq edit_student_path(@student)
    end

    it "stays on the same page on validation errors" do
      visit edit_student_path(@student)
      fill_in "Korisničko ime", with: ""
      click_on "Spremi"

      current_path.should eq student_path(@student)
    end

    it "redirects back to the account page on success" do
      visit edit_student_path(@student)
      click_on "Spremi"

      current_path.should eq student_path(@student)
    end
  end

  context "when deleting account" do
    it "has a link on the account page" do
      visit student_path(@student)
      click_on "Izbriši korisnički račun"
      current_path.should eq delete_student_path(@student)
    end

    it "stays on the same page on validation errors" do
      visit delete_student_path(@student)
      click_on "Potvrdi"
      current_path.should eq student_path(@student)
    end

    it "redirects back to root on success" do
      visit delete_student_path(@student)
      fill_in "Lozinka", with: attributes_for(:student)[:password]
      expect { click_on "Potvrdi" }.to change{Student.count}.by(-1)
      current_path.should eq root_path
    end
  end
end
