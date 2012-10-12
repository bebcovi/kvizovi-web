require "spec_helper_full"

describe "Changing password" do
  before(:all) do
    @school = create(:school)
    @student = create(:student, school: @school)
  end

  context "for student" do
    before(:each) { login(:student, attributes_for(:student)) }

    it "has the link path" do
      visit student_path(@student)
      click_on "Izmjeni lozinku"
      current_path.should eq edit_password_path
    end

    it "checks for validation errors" do
      visit edit_password_path
      click_on "Spremi"
      current_path.should eq password_path
    end

    it "successfully changes the password" do
      visit edit_password_path
      fill_in "Stara lozinka", with: attributes_for(:student)[:password]
      fill_in "Nova lozinka", with: "new password"
      fill_in "Potvrda nove lozinke", with: "new password"
      click_on "Spremi"

      current_path.should eq student_path(@student)
      @student.reload.authenticate("new password").should be_true
    end
  end

  context "for school" do
    before(:each) { login(:school, attributes_for(:school)) }

    it "has the link path" do
      visit school_path(@school)
      click_on "Izmjeni lozinku"
      current_path.should eq edit_password_path
    end

    it "checks for validation errors" do
      visit edit_password_path
      click_on "Spremi"
      current_path.should eq password_path
    end

    it "successfully changes the password" do
      visit edit_password_path
      fill_in "Stara lozinka", with: attributes_for(:school)[:password]
      fill_in "Nova lozinka", with: "new password"
      fill_in "Potvrda nove lozinke", with: "new password"
      click_on "Spremi"

      current_path.should eq school_path(@school)
      @school.reload.authenticate("new password").should be_true
    end
  end

  after(:all) { @school.destroy }
end
