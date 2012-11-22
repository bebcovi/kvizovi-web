require "spec_helper_full"

describe "Creating quizzes" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  let(:attributes) { attributes_for(:quiz) }

  it "has the link for it on the quizzes page" do
    visit quizzes_path
    click_on "Novi kviz"
    current_path.should eq new_quiz_path
  end

  it "stays on the same page on validation errors" do
    visit new_quiz_path
    expect { click_on "Stvori" }.to_not change{@school.quizzes.count}
    page.should have_css("form.new_quiz")
  end

  it "redirects back to quizzes on success" do
    visit new_quiz_path

    fill_in "Naziv", with: attributes[:name]
    expect { click_on "Stvori" }.to change{@school.quizzes.count}.by(1)

    current_path.should eq quizzes_path
  end

  after(:all) { @school.destroy }
end
