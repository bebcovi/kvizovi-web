# encoding: utf-8
require "spec_helper_full"

describe "Student login" do
  before(:all) {
    @school = create(:school)
    @student = create(:student, school: @school)
  }

  let(:attributes) { attributes_for(:student) }

  it "has the link for it on the root page" do
    visit root_path
    find_link("Ja sam učenik")[:href].should eq login_path(type: "student")
  end

  it "stays on the same page on validation errors" do
    visit login_path(type: "student")
    click_on "Prijava"
    current_path.should eq login_path
  end

  it "logs in the student, and redirects to the new game" do
    visit login_path(type: "student")
    fill_in "Korisničko ime", with: attributes[:username]
    fill_in "Lozinka", with: attributes[:password]
    click_on "Prijava"

    current_path.should eq new_game_path
    page.should have_content(attributes[:first_name])
  end
end
