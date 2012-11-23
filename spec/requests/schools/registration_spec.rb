# encoding: utf-8
require "spec_helper_full"

describe "School registration" do
  let(:attributes) { attributes_for(:school) }

  it "has the link for it on the login page" do
    visit login_path(type: "school")
    find_link("Registrirajte se")[:href].should eq new_school_path
  end

  it "is required to authorize" do
    visit new_school_path
    current_path.should eq authorize_path
  end

  describe "authorizing" do
    it "stays on the same page on validation errors" do
      visit authorize_path
      fill_in "Tajni ključ aplikacije", with: "wrong key"
      click_on "Potvrdi"
      current_path.should eq authorize_path
    end

    it "proceeds to the registration page on success" do
      visit authorize_path
      fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
      click_on "Potvrdi"
      current_path.should eq new_school_path
    end
  end

  def authorize
    visit authorize_path
    fill_in "Tajni ključ aplikacije", with: ENV["LEKTIRE_KEY"]
    click_on "Potvrdi"
  end

  it "stays on the same page on validation errors" do
    authorize
    expect { click_on "Registriraj se" }.to_not change{School.count}
    current_path.should eq schools_path
  end

  it "gets redirected to its quizzes with example quizzes created" do
    authorize

    fill_in "Ime škole", with: attributes[:name]
    select attributes[:level], from: "Tip škole"
    fill_in "Mjesto", with: attributes[:place]
    select attributes[:region], from: "Županija"
    fill_in "Korisničko ime", with: attributes[:username]
    fill_in "Lozinka", with: attributes[:password]
    fill_in "Email", with: attributes[:email]
    fill_in "Potvrda lozinke", with: attributes[:password]
    fill_in "Tajni ključ", with: attributes[:key]

    expect { click_on "Registriraj se" }.to change{School.count}.by 1

    School.first.quizzes.should_not be_empty
    current_path.should eq quizzes_path
    page.should have_content(attributes[:username])
  end
end
