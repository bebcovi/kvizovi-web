# encoding: utf-8
require "spec_helper_full"

describe "Managing profile" do
  before(:all) do
    @school = create(:school)
    @student = create(:student, school: @school)
  end

  describe "Updating profile" do
    context "of a school" do
      before(:each) { login(:school, attributes_for(:school)) }

      it "has a link on the account page" do
        visit school_path(@school)
        click_on "Izmjeni profil"
        current_path.should eq edit_school_path(@school)
      end

      it "stays on the same page on validation errors" do
        visit edit_school_path(@school)
        fill_in "Korisničko ime", with: ""
        click_on "Spremi"

        current_path.should eq school_path(@school)
      end

      it "redirects back to the account page on success" do
        visit edit_school_path(@school)
        click_on "Spremi"

        current_path.should eq school_path(@school)
      end
    end

    context "of a student" do
      before(:each) { login(:student, attributes_for(:student)) }

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
  end

  describe "Deleting account" do
    context "of a student" do
      before(:each) { login(:student, attributes_for(:student)) }

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

    context "of a school" do
      before(:each) { login(:school, attributes_for(:school)) }

      it "has a link on the account page" do
        visit school_path(@school)
        click_on "Izbriši korisnički račun"
        current_path.should eq delete_school_path(@school)
      end

      it "stays on the same page on validation errors" do
        visit delete_school_path(@school)
        click_on "Potvrdi"
        current_path.should eq school_path(@school)
      end

      it "redirects back to root on success" do
        visit delete_school_path(@school)
        fill_in "Lozinka", with: attributes_for(:school)[:password]
        expect { click_on "Potvrdi" }.to change{School.count}.by(-1)
        current_path.should eq root_path
      end
    end
  end
end
