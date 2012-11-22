require "spec_helper_full"

describe "Changing school's password" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  let(:attributes) { attributes_for(:school) }

  it "has the link for it on the profile page" do
    visit school_path(@school)
    click_on "Izmjeni lozinku"
    current_path.should eq edit_password_path
  end

  it "stays on the same page on validation errors" do
    visit edit_password_path
    click_on "Spremi"
    current_path.should eq password_path
  end

  it "gets redirected back to its profile with its password changed" do
    visit edit_password_path
    fill_in "Stara lozinka", with: attributes[:password]
    fill_in "Nova lozinka", with: "new password"
    fill_in "Potvrda nove lozinke", with: "new password"
    click_on "Spremi"

    current_path.should eq school_path(@school)
    @school.reload.authenticate("new password").should be_true
  end
end
