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

      it "redirects back to the school" do
        visit school_path(@school)
        click_on "Izmjeni profil"
        click_on "Spremi"

        current_path.should eq school_path(@school)
      end
    end

    context "of a student" do
      before(:each) { login(:student, attributes_for(:student)) }

      it "redirects back to the school" do
        visit student_path(@student)
        click_on "Izmjeni profil"
        click_on "Spremi"

        current_path.should eq student_path(@student)
      end
    end
  end

  describe "Deleting account" do
    context "of a student" do
      before(:each) { login(:student, attributes_for(:student)) }

      it "redirects back to root" do
        visit student_path(@student)
        expect { click_on "Izbriši korisnički račun" }.to change{Student.count}.by(-1)
        current_path.should eq root_path
      end
    end

    context "of a school" do
      before(:each) { login(:school, attributes_for(:school)) }

      it "redirects back to root" do
        visit school_path(@school)
        expect { click_on "Izbriši korisnički račun" }.to change{School.count}.by(-1)
        current_path.should eq root_path
      end
    end
  end
end
