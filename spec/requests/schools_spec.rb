require "spec_helper_full"

describe "Schools" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  they "can access their profiles from any page" do
    click_on "Uredi profil"
    current_path.should eq school_path(@school)
  end
end
