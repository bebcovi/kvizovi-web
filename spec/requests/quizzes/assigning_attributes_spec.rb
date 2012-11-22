require "spec_helper_full"

describe "Assigning attributes to quizzes" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  }
  before(:each) {
    login(:school, attributes_for(:school))
    @quiz.update_attributes(attributes_for(:quiz))
  }

  it "assigns grades correctly" do
    @quiz.update_attributes(grades: [])
    visit edit_quiz_path(@quiz)
    ["1a", "2b", "4d"].each { |grade| check grade }
    expect { click_on "Spremi" }.to change{@quiz.reload.grades}.from([]).to(["1a", "2b", "4d"])
  end

  after(:all) { @school.destroy }
end
