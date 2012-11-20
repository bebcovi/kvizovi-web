# encoding: utf-8
require "spec_helper_full"

describe "Questions" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }

  describe "including a question into a quiz" do
    before(:all) { @question = create(:question, school: @school) }
    before(:each) { @question.connection.execute "DELETE FROM questions_quizzes WHERE question_id = '#{@question.id}' AND quiz_id = '#{@quiz.id}'" }

    it "includes the question" do
      visit quiz_questions_path(@quiz)

      click_on "Uključi pitanje"
      page.should have_content(@question.content)
      expect {
        within(".btn-group") { all("a").first.click }
      }.to change{@quiz.questions.count}.by 1

      current_path.should eq school_questions_path(@school)
    end

    it "doesn't create a new question" do
      visit quiz_questions_path(@quiz)

      click_on "Uključi pitanje"
      expect {
        within(".btn-group") { all("a").first.click }
      }.to_not change{Question.count}
    end

    it "doesn't show the question again if included" do
      visit quiz_questions_path(@quiz)

      click_on "Uključi pitanje"
      page.should have_content(@question.content)
      within(".btn-group") { all("a").first.click }
      page.should_not have_content(@question.content)
    end

    it "can be finished" do
      visit quiz_questions_path(@quiz)

      click_on "Uključi pitanje"
      click_on "Završi"

      current_path.should eq quiz_questions_path(@quiz)
    end

    after(:all) { @question.destroy }
  end

  describe "removing question from a quiz" do
    before(:all) { @question = create(:question, school: @school) }
    before(:each) { @question.quizzes << @quiz }

    it "removes the question from the quiz" do
      visit quiz_questions_path(@quiz)

      expect {
        within(".btn-group") { all("a").last.click }
      }.to change{@quiz.questions.count}.by -1
    end

    it "does not delete the question" do
      visit quiz_questions_path(@quiz)

      expect {
        within(".btn-group") { all("a").last.click }
      }.to_not change{@school.questions.count}
    end

    after(:all) { @question.destroy }
  end

  after(:all) { @school.destroy }
end
