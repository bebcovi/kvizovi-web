require "spec_helper_full"

describe "Students" do
  before(:all) {
    @school = create(:school)
    @student = create(:student, school: @school)
  }
  before(:each) { login(:student, attributes_for(:student)) }

  they "can access their profiles from any page" do
    click_on "Uredi profil"
    current_path.should eq student_path(@student)
  end
end
