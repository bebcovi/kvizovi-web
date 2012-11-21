require "spec_helper_full"

describe "Copying questions" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  context "from quiz" do
    before(:all) {
      @quiz = create(:quiz, school: @school)
      @question = create(:question, school: @school, quizzes: [@quiz])
    }

    it "copies the question" do
      visit quiz_questions_path(@quiz)

      within(".actions .dropdown-menu") { all("a").third.click }
      expect { click_on "Stvori" }.to change{@quiz.questions.count}.by 1

      current_path.should eq quiz_questions_path(@quiz)

      copied_question = @school.questions.first
      copied_question.should_not eq @question
      copied_question.content.strip.should eq @question.content

      copied_question.destroy
    end

    after(:all) {
      @question.destroy
      @quiz.destroy
    }
  end

  context "from logged in school" do
    before(:all) { @question = create(:question, school: @school) }

    it "copies the question" do
      visit school_questions_path(@school)

      within(".actions .dropdown-menu") { all("a").third.click }
      expect { click_on "Stvori" }.to change{@school.questions.count}.by 1

      current_path.should eq school_questions_path(@school)

      copied_question = @school.questions.first
      copied_question.should_not eq @question
      copied_question.content.strip.should eq @question.content

      copied_question.destroy
    end

    after(:all) { @question.destroy }
  end

  context "from other schools" do
    before(:all) {
      @other_school = create(:other_school)
      @question = create(:question, school: @other_school)
    }

    it "moves the question to the currently logged in school" do
      visit questions_path

      within(".actions .dropdown-menu") { all("a").second.click }
      expect { click_on "Stvori" }.to change{@school.questions.count}.by 1

      current_path.should eq school_questions_path(@school)

      copied_question = @school.questions.first
      copied_question.should_not eq @question
      copied_question.content.strip.should eq @question.content

      copied_question.destroy
    end

    after(:all) {
      @question.destroy
      @other_school.destroy
    }
  end

  after(:all) { @school.destroy }
end
