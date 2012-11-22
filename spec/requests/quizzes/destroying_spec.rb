require "spec_helper_full"

describe "Destroying quizzes" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }

  it "has the link for it" do
    visit quizzes_path
    within(".dropdown-menu") { all("a").last.click }
    current_path.should eq delete_quiz_path(@quiz)
  end

  it "can cancel it" do
    visit delete_quiz_path(@quiz)
    expect { click_on "Nisam" }.to_not change{@school.quizzes.count}
    current_path.should eq quizzes_path
  end

  it "can confirm it" do
    visit delete_quiz_path(@quiz)
    expect { click_on "Jesam" }.to change{@school.quizzes.count}.by(-1)
    current_path.should eq quizzes_path
  end

  after(:all) { @school.destroy }
end
