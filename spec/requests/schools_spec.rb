# encoding: utf-8
require "spec_helper_full"

describe "School" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  context "when updating profile" do
    it "has a link on the account page" do
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

    it "redirects back to the account page on success" do
      visit edit_school_path(@school)
      click_on "Spremi"

      current_path.should eq school_path(@school)
    end
  end

  context "when it wants to try out its quiz" do
    before(:all) do
      @quiz = create(:quiz, school: @school)
      create(:boolean_question, quiz: @quiz)
    end

    it "has the link for it on the quiz page" do
      visit quiz_questions_path(@quiz)
      click_on "Isprobajte kviz"
      current_path.should eq edit_game_path
    end

    it "is redirected back to the quiz when the game is interrupted" do
      visit quiz_questions_path(@quiz)
      click_on "Isprobajte kviz"
      click_on "Prekini"
      click_on "Jesam"
      current_path.should eq quiz_questions_path(@quiz)
    end

    it "goes back to the quiz when the game is finished" do
      visit quiz_questions_path(@quiz)
      click_on "Isprobajte kviz"
      click_on "Odgovori"
      within(".form_controls") { find("*").click }
      click_on "Završi"
      current_path.should eq quiz_questions_path(@quiz)
    end
  end

  context "when deleting account" do
    it "has a link on the account page" do
      visit school_path(@school)
      click_on "Izbriši korisnički račun"
      current_path.should eq delete_school_path(@school)
    end

    it "stays on the same page on validation errors" do
      visit delete_school_path(@school)
      click_on "Potvrdi"
      current_path.should eq school_path(@school)
    end

    it "redirects back to root on success" do
      visit delete_school_path(@school)
      fill_in "Lozinka", with: attributes_for(:school)[:password]
      expect { click_on "Potvrdi" }.to change{School.count}.by(-1)
      current_path.should eq root_path
    end
  end
end
