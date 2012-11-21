require "spec_helper_full"

describe "Removing questions from a quiz" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
    @question = create(:question, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }
  before(:each) { @question.quizzes << @quiz }

  it "removes the question" do
    visit quiz_questions_path(@quiz)

    expect {
      within(".actions .dropdown-menu") { all("a").last.click }
    }.to change{@quiz.questions.count}.by -1
  end

  it "does not delete the question" do
    visit quiz_questions_path(@quiz)

    expect {
      within(".actions .dropdown-menu") { all("a").last.click }
    }.to_not change{@school.questions.count}
  end

  after(:all) { @school.destroy }
end
