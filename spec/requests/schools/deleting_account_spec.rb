# encoding: utf-8
require "spec_helper_full"

describe "Deleting school's account" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  let(:attributes) { attributes_for(:school) }

  it "has the link for it on the profile page" do
    visit school_path(@school)
    click_on "Izbriši korisnički račun"
    current_path.should eq delete_school_path(@school)
  end

  it "stays on the same page on validation errors" do
    visit delete_school_path(@school)
    click_on "Potvrdi"
    current_path.should eq school_path(@school)
  end

  it "gets redirected to root on success" do
    visit delete_school_path(@school)
    fill_in "Lozinka", with: attributes[:password]
    expect { click_on "Potvrdi" }.to change{School.count}.by(-1)
    current_path.should eq root_path
  end
end
