require "spec_helper_full"

describe "Making public" do
  before(:all) {
    @school = create(:school)
    @question = create(:question, school: @school)
    @other_school = create(:other_school)
  }

  it "hides questions" do
    login(:school, attributes_for(:other_school))
    visit questions_path
    page.should have_content(@question.content)
    logout

    login(:school, attributes_for(:school))
    visit school_path(@school)
    click_on "Pitanja su javna"
    logout

    login(:school, attributes_for(:other_school))
    visit questions_path
    page.should_not have_content(@question.content)
  end
end
