require "spec_helper_full"

describe "Downloading questions" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  context "from other schools" do
    before(:all) {
      @other_school = create(:other_school)
      @question = create(:question, school: @other_school)
    }

    it "moves the question to the currently logged in school" do
      visit questions_path

      expect {
        within(".actions .dropdown-menu") { all("a").second.click }
      }.to change{@school.questions.count}.by 1

      current_path.should eq school_questions_path(@school)

      page.should have_css(".highlight")
      visit current_path
      page.should_not have_css(".highlight")

      copied_question = @school.questions.first
      copied_question.should_not eq @question
      copied_question.content.strip.should eq @question.content

      copied_question.destroy
    end

    it "can be done when viewing" do
      visit questions_path

      within(".actions .dropdown-menu") { all("a").first.click }
      expect { click_on "Kopiraj kod sebe" }.to change{@school.questions.count}.by 1

      current_path.should eq school_questions_path(@school)
    end

    after(:all) {
      @question.destroy
      @other_school.destroy
    }
  end

  after(:all) { @school.destroy }
end
