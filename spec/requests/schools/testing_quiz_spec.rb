# encoding: utf-8
require "spec_helper_full"

describe "Testing quiz" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
    create(:question, quizzes: [@quiz])
  }
  before(:each) { login(:school, attributes_for(:school)) }

  it "has the link for it on the quiz page" do
    visit quiz_questions_path(@quiz)
    click_on "Testiraj kviz"
    current_path.should eq edit_game_path
  end

  it "gets redirected back to the quiz when the game is interrupted" do
    visit quiz_questions_path(@quiz)
    click_on "Testiraj kviz"
    click_on "Prekini"
    click_on "Jesam"
    current_path.should eq quiz_questions_path(@quiz)
  end

  it "gets redirected back to the quiz" do
    visit quiz_questions_path(@quiz)
    click_on "Testiraj kviz"
    click_on "Odgovori"
    within(".btn-toolbar") { find("*").click }
    click_on "Završi"
    current_path.should eq quiz_questions_path(@quiz)
  end
end
