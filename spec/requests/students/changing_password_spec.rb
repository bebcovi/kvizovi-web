require "spec_helper_full"

describe "Changing student's password" do
  before(:all) {
    @school = create(:school)
    @student = create(:student, school: @school)
  }
  before(:each) { login(:student, attributes_for(:student)) }

  let(:attributes) { attributes_for(:student) }

  it "has the link for it on the profile page" do
    visit student_path(@student)
    click_on "Izmjeni lozinku"
    current_path.should eq edit_password_path
  end

  it "stays on the same page on validation errors" do
    visit edit_password_path
    click_on "Spremi"
    current_path.should eq password_path
  end

  it "redirects back to student's profile with its password changed on success" do
    visit edit_password_path
    fill_in "Stara lozinka", with: attributes[:password]
    fill_in "Nova lozinka", with: "new password"
    fill_in "Potvrda nove lozinke", with: "new password"
    click_on "Spremi"

    current_path.should eq student_path(@student)
    @student.reload.authenticate("new password").should be_true
  end
end
