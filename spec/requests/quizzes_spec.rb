# encoding: utf-8
require "spec_helper_full"

describe "Quizzes" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  describe "creating" do
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
  end

  describe "updating" do
    before(:all) { @quiz = create(:quiz, school: @school) }

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

    after(:all) { @quiz.destroy }
  end

  describe "destroying" do
    before(:all) { @quiz = create(:quiz, school: @school) }

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
  end

  after(:all) { @school.destroy }
end
