# encoding: utf-8
require "spec_helper_full"

describe "Deleting student's account" do
  before(:all) {
    @school = create(:school)
    @student = create(:student, school: @school)
  }
  before(:each) { login(:student, attributes_for(:student)) }

  it "has the link for it on the profile page" do
    visit student_path(@student)
    click_on "Izbriši korisnički račun"
    current_path.should eq delete_student_path(@student)
  end

  it "stays on the same page on validation errors" do
    visit delete_student_path(@student)
    click_on "Potvrdi"
    current_path.should eq student_path(@student)
  end

  it "redirects to root on success" do
    visit delete_student_path(@student)

    fill_in "Lozinka", with: attributes_for(:student)[:password]
    expect { click_on "Potvrdi" }.to change{Student.count}.by(-1)

    current_path.should eq root_path
  end
end
