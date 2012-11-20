# encoding: utf-8
require "spec_helper_full"

describe "School" do
  before(:all) { @school = create(:school) }

  before(:each) { login(:school, attributes_for(:school)) }

  context "when creating quizzes" do
    it "has the link for it on the quizzes page" do
      visit quizzes_path
      click_on "Novi kviz"
      current_path.should eq new_quiz_path
    end

    context "on validation errors" do
      it "is held on the same page" do
        visit new_quiz_path
        expect { click_on "Stvori" }.to_not change{@school.quizzes.count}
        current_path.should eq quizzes_path
      end
    end

    context "on success" do
      let(:attributes) { attributes_for(:quiz) }

      it "gets redirected back to the quizzes page" do
        visit new_quiz_path

        fill_in "Naziv", with: attributes[:name]
        expect { click_on "Stvori" }.to change{@school.quizzes.count}.by(1)

        current_path.should eq quizzes_path
      end
    end

    after(:all) { @school.quizzes.destroy_all }
  end

  context "when updating quizzes" do
    before(:all) { @quiz = create(:quiz, school: @school) }

    it "has the link for it" do
      visit quiz_questions_path(@quiz)
      click_on "Izmjeni informacije"
      current_path.should eq edit_quiz_path(@quiz)
    end

    context "on validation errors" do
      it "is held on the same page" do
        visit edit_quiz_path(@quiz)
        fill_in "Naziv", with: ""
        click_on "Spremi"
        current_path.should eq quiz_path(@quiz)
      end
    end

    context "on success" do
      it "gets redirected back to quizzes" do
        visit edit_quiz_path(@quiz)
        click_on "Spremi"
        current_path.should eq quiz_questions_path(@quiz)
      end
    end

    it "can toggle the activation" do
      visit quizzes_path

      expect { click_on "Deaktiviraj" }.to change{@quiz.reload.activated?}.from(true).to(false)
      expect { click_on "Aktiviraj" }.to change{@quiz.reload.activated?}.from(false).to(true)

      current_path.should eq(quizzes_path)
    end

    after(:all) { @quiz.destroy }
  end

  describe "when destroying a quiz" do
    before(:all) { @quiz = create(:quiz, school: @school) }

    it "has the link for it" do
      visit quizzes_path
      within(".btn-group") { all("a").last.click }
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
