require "spec_helper_full"

describe "Destroying questions" do
  before(:all) {
    @school = create(:school)
    @question = create(:question, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }

  it "has a link for it" do
    visit school_questions_path(@school)
    within(".actions .dropdown-menu") { all("a").last.click }
    current_path.should eq delete_school_question_path(@school, @question)
  end

  it "can be canceled" do
    visit delete_school_question_path(@school, @question)
    click_on "Nisam"
    current_path.should eq school_questions_path(@school)
  end

  it "can be confirmed" do
    visit delete_school_question_path(@school, @question)
    expect { click_on "Jesam" }.to change{@school.questions.count}.by(-1)
    current_path.should eq school_questions_path(@school)
  end

  after(:all) { @school.destroy }
end
