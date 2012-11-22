# encoding: utf-8
require "spec_helper_full"

describe "Updating school" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  it "has the link for it on the profile page" do
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

  it "redirects back to the profile on success" do
    visit edit_school_path(@school)
    fill_in "Ime škole", with: "Ime škole"
    expect { click_on "Spremi" }.to change{@school.reload.updated_at}
    current_path.should eq school_path(@school)
  end
end
