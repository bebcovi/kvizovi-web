# encoding: utf-8
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

  after(:all) { @school.destroy }
end

describe "Resetting school's password" do
  before(:all) { @school = create(:school) }

  it "has a link for it on the login page" do
    visit login_path(type: "school")
    click_on "Zatražite novu"
    current_path.should eq new_password_path
  end

  it "gets a randomly generated password" do
    visit new_password_path
    fill_in "email", with: @school.email
    expect {
      click_on "Zatraži novu lozinku"
    }.to change{@school.reload.password_digest}

    current_path.should eq login_path
    page.should have_css(".alert-success")
    @school.password_digest.should be_present
  end

  after(:all) { @school.destroy }
end
