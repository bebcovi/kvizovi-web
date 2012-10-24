# encoding: utf-8
require "spec_helper_full"

describe "Managing quizzes" do
  before(:all) { @school = create(:school) }

  before(:each) { login(:school, attributes_for(:school)) }

  describe "create" do
    before(:all) { @quiz = build(:quiz, school: @school) }

    it "has a link" do
      visit quizzes_path
      click_on "Novi kviz"
      current_path.should eq new_quiz_path
    end

    it "stays on the same page on validation errors" do
      visit new_quiz_path

      click_on "Stvori"

      current_path.should eq quizzes_path
    end

    it "redirects back to quizzes on success" do
      visit new_quiz_path

      fill_in "Naziv", with: @quiz.name
      check ordinalize(@quiz.grades).first
      expect { click_on "Stvori" }.to change{Quiz.count}.by(1)

      current_path.should eq quizzes_path
    end
  end

  describe "update" do
    before(:all) { @quiz = Quiz.last }

    it "has a link" do
      visit quizzes_path
      within(".controls") { first("a").click }
      current_path.should eq edit_quiz_path(@quiz)
    end

    it "stays on the same page on validation errors" do
      visit edit_quiz_path(@quiz)

      fill_in "Naziv", with: ""
      click_on "Spremi"

      current_path.should eq quiz_path(@quiz)
    end

    it "redirects back to quizzes on success" do
      visit edit_quiz_path(@quiz)

      click_on "Spremi"

      current_path.should eq(quizzes_path)
    end

    describe "activation" do
      context "when valid" do
        before(:each) do
          Quiz.any_instance.stub(:questions).and_return([
            build(:boolean_question),
            build(:boolean_question)
          ])
        end

        it "can be toggled" do
          visit quizzes_path

          expect { within("form") { first("button").click } }.to change{@quiz.reload.activated?}.from(false).to(true)
          expect { within("form") { first("button").click } }.to change{@quiz.reload.activated?}.from(true).to(false)

          current_path.should eq(quizzes_path)
        end
      end

      context "when invalid" do
        it "can't be toggled" do
          visit quizzes_path
          expect { first("button").click }.to_not change{@quiz.reload.activated?}
        end

        it "displays validation errors" do
          visit quizzes_path
          first("button").click
          current_path.should eq(quizzes_path)
          all(".flash.alert").should_not be_empty
        end
      end
    end

    after(:all) { @quiz.destroy }
  end

  describe "destroy" do
    before(:all) { @quiz = create(:quiz, school: @school) }

    it "has a link" do
      visit quizzes_path
      within(".controls") { all("a").last.click }
      current_path.should eq delete_quiz_path(@quiz)
    end

    it "can be canceled" do
      visit delete_quiz_path(@quiz)
      expect { click_on "Nisam" }.to_not change{Quiz.count}
      current_path.should eq quizzes_path
    end

    it "can be confirmed" do
      visit delete_quiz_path(@quiz)
      expect { click_on "Jesam" }.to change{Quiz.count}.by(-1)
      current_path.should eq quizzes_path
    end
  end

  after(:all) { @school.destroy }
end
