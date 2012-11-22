require "spec_helper_full"

describe "Updating quizzes" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  }
  before(:each) { login(:school, attributes_for(:school)) }

  it "has the link for it inside quiz" do
    visit quiz_questions_path(@quiz)
    click_on "Izmjeni informacije"
    current_path.should eq edit_quiz_path(@quiz)
  end

  it "has the link for it outside quiz" do
    visit quizzes_path
    within(".actions .dropdown-menu") { all("a").second.click }
    current_path.should eq edit_quiz_path(@quiz)
  end

  it "stays on the same page on validation errors" do
    visit edit_quiz_path(@quiz)
    fill_in "Naziv", with: ""
    click_on "Spremi"
    page.should have_css("form.edit_quiz")
  end

  it "gets redirected back to quizzes on success" do
    visit edit_quiz_path(@quiz)
    click_on "Spremi"
    current_path.should eq quiz_questions_path(@quiz)
  end

  it "can toggle the activation" do
    visit quizzes_path

    expect { click_on "Deaktiviraj" }.to change{@quiz.reload.activated?}.from(true).to(false)
    expect { click_on "Aktiviraj" }.to change{@quiz.reload.activated?}.from(false).to(true)

    current_path.should eq(quizzes_path)
  end

  after(:all) { @school.destroy }
end
