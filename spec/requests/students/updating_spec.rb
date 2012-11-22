# encoding: utf-8
require "spec_helper_full"

describe "Updating student" do
  before(:all) {
    @school = create(:school)
    @student = create(:student, school: @school)
  }
  before(:each) { login(:student, attributes_for(:student)) }

  it "has the link for it on the profile page" do
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

  it "redirects back to student's profile" do
    visit edit_student_path(@student)
    fill_in "Ime", with: "Ime"
    expect { click_on "Spremi" }.to change{@student.reload.updated_at}
    current_path.should eq student_path(@student)
  end
end
