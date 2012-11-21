require "spec_helper_full"

describe "Updating questions" do
  before(:all) {
    @school = create(:school)
    @question = create(:question, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }

  it "stays on the same page on validation errors" do
    visit edit_school_question_path(@school, @question)
    fill_in "Tekst pitanja", with: ""
    click_on "Spremi"
    page.should have_css("form#edit_question")
  end

  context "inside school" do
    it "has a link for it" do
      visit school_questions_path(@school)
      within(".actions .dropdown-menu") { all("a").second.click }
      current_path.should eq edit_school_question_path(@school, @question)
    end

    it "can be canceled" do
      visit edit_school_question_path(@school, @question)
      expect { click_on "Odustani" }.to_not change{@question.reload.updated_at}
      current_path.should eq school_questions_path(@school)
    end

    it "can be confirmed" do
      visit edit_school_question_path(@school, @question)
      expect { click_on "Spremi" }.to change{@question.reload.updated_at}
      current_path.should eq school_questions_path(@school)
    end
  end

  context "inside quiz" do
    before(:all) {
      @quiz = create(:quiz, school: @school)
      @question.quizzes << @quiz
    }

    it "has a link for it" do
      visit quiz_questions_path(@quiz)
      within(".actions .dropdown-menu") { all("a").second.click }
      current_path.should eq edit_quiz_question_path(@quiz, @question)
    end

    it "can be canceled" do
      visit edit_quiz_question_path(@quiz, @question)
      expect { click_on "Odustani" }.to_not change{@question.reload.updated_at}
      current_path.should eq quiz_questions_path(@quiz)
    end

    it "can be confirmed" do
      visit edit_quiz_question_path(@quiz, @question)
      expect { click_on "Spremi" }.to change{@question.reload.updated_at}
      current_path.should eq quiz_questions_path(@quiz)
    end
  end

  after(:all) { @school.destroy }
end
