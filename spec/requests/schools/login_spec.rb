# encoding: utf-8
require "spec_helper_full"

describe "School login" do
  before(:all) { @school = create(:school) }
  let(:attributes) { attributes_for(:school) }

  it "has the link for it on the root page" do
    visit root_path
    click_on "Ja sam škola"
    current_path.should eq login_path
  end

  it "stays on the same page on validation errors" do
    visit login_path(type: "school")
    click_on "Prijava"
    current_path.should eq login_path
  end

  it "logs in and redirects to school's quizzes on success" do
    visit login_path(type: "school")
    fill_in "Korisničko ime", with: attributes[:username]
    fill_in "Lozinka", with: attributes[:password]
    click_on "Prijava"

    current_path.should eq quizzes_path
    page.should have_content(attributes[:name])
  end
end
