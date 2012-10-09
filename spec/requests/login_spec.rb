# encoding: utf-8
require "spec_helper_full"

shared_examples_for "login" do
  it "works as expected" do
    visit_login_page
    fill_in "Korisničko ime", with: @user.username
    fill_in "Lozinka", with: "wrong"
    click_on "Prijava"
    current_path.should eq(login_path)
    page.should have_content("Pogrešno korisničko ime ili lozinka.")

    find_field("Korisničko ime").value.should eq(@user.username)
    find_field("Lozinka").value.should be_nil
    fill_in "Lozinka", with: @user.password
    click_on "Prijava"
    current_path.should eq(home_path)
    find("#log").should have_link(name)
  end

  it "handles the 'remember_me' check box" do
    visit_login_page
    fill_in "Korisničko ime", with: @user.username
    fill_in "Lozinka", with: @user.password
    click_on "Prijava"

    current_path.should eq(home_path)
    cookie.expires.should be_nil
    logout

    visit_login_page
    fill_in "Korisničko ime", with: @user.username
    fill_in "Lozinka", with: @user.password
    check("Zapamti me")
    click_on "Prijava"

    current_path.should eq(home_path)
    cookie.expires.should be > 10.years.from_now
  end
end

describe SessionsController do
  context "of students" do
    it_behaves_like "login" do
      before(:each) do
        @user = build_stubbed(:student)
        @user.stub(:school) { build_stubbed(:school, quizzes: []) }
        Student.stub(:find_by_username) { @user }
        Student.stub(:find) { @user }
      end

      def visit_login_page
        visit root_path
        click_on "Ja sam učenik"
      end

      let(:login_path) { student_login_path }
      let(:home_path)  { new_game_path }

      let(:name) { @user.first_name }
      def cookie; cookies[:student_id] end
    end
  end

  context "of schools" do
    it_behaves_like "login" do
      before(:each) do
        @user = build_stubbed(:school)
        School.stub(:find_by_username) { @user }
        School.stub(:find) { @user }
      end

      def visit_login_page
        visit root_path
        click_on "Ja sam škola"
      end

      let(:login_path) { school_login_path }
      let(:home_path)  { quizzes_path }

      let(:name) { @user.name }
      def cookie; cookies[:school_id] end
    end
  end
end
