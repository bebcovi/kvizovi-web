# encoding: utf-8
require "spec_helper_full"

describe "Including questions in a quiz" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
    @question = create(:question, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }
  before(:each) { @question.connection.execute "DELETE FROM questions_quizzes WHERE question_id = '#{@question.id}' AND quiz_id = '#{@quiz.id}'" }

  it "includes the question" do
    visit quiz_questions_path(@quiz)

    click_on "Pridruži pitanja"
    page.should have_content(@question.content)
    expect {
      within(".actions .dropdown-menu") { all("a").second.click }
    }.to change{@quiz.questions.count}.by 1

    current_path.should eq school_questions_path(@school)
  end

  it "doesn't create a new question" do
    visit quiz_questions_path(@quiz)

    click_on "Pridruži pitanja"
    expect {
      within(".actions .dropdown-menu") { all("a").second.click }
    }.to_not change{Question.count}
  end

  it "doesn't show the question again if included" do
    visit quiz_questions_path(@quiz)

    click_on "Pridruži pitanja"
    page.should have_content(@question.content)
    within(".actions .dropdown-menu") { all("a").second.click }
    page.should_not have_content(@question.content)
  end

  it "can be finished" do
    visit quiz_questions_path(@quiz)

    click_on "Pridruži pitanja"
    click_on "Završi"

    current_path.should eq quiz_questions_path(@quiz)
  end

  after(:all) { @school.destroy }
end
