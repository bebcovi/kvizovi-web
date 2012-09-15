# encoding: utf-8
require "spec_helper"

describe "Managing quizzes" do
  before(:all) do
    @school = create(:school)
  end

  before(:each) do
    login(@school)
  end

  describe "create" do
    before(:all) do
      @quiz = build_stubbed(:quiz)
    end

    let(:quiz) { @quiz }

    def fill_in_the_form
      fill_in "Naziv", with: quiz.name
      check ordinalize(quiz.grades).first
    end

    it "has a link" do
      visit quizzes_path
      find_link("Novi kviz")[:href].should eq(new_quiz_path)
    end

    it "has a notice for visibility" do
      visit new_quiz_path
      page.should have_selector(".notice")
    end

    it "keeps all the fields filled in upon validation errors" do
      visit new_quiz_path

      fill_in_the_form
      fill_in "Naziv", with: ""
      click_on "Stvori"

      current_path.should eq(quizzes_path)
      find_field("Prvi").should be_checked
    end

    it "redirects to the quiz on success" do
      visit new_quiz_path

      fill_in_the_form
      expect { click_on "Stvori" }.to change{Quiz.count}.from(0).to(1)

      current_path.should eq(quiz_questions_path(Quiz.first))
      page.should have_content("Kviz je uspješno stvoren.")
    end

    after(:all) do
      Quiz.destroy_all
    end
  end

  describe "update" do
    before(:all) do
      @quiz = create(:quiz, school: @school)
    end

    let(:quiz) { @quiz }

    context "from form" do
      it "has a link" do
        visit quizzes_path
        within(".controls") { first("a")[:href].should eq(edit_quiz_path(quiz)) }
      end

      it "has all fields filled in" do
        visit edit_quiz_path(quiz)

        find_field("Naziv").value.should_not be_nil
        find_field("Prvi").should be_checked
      end

      it "redirects back to the form on validation errors" do
      end

      it "redirects back to quizzes on success" do
        visit edit_quiz_path(quiz)
        click_on "Spremi"
        current_path.should eq(quizzes_path)
      end
    end

    context "from icon" do
      it "has a link" do
        visit quizzes_path
        first("form")[:action].should eq(quiz_path(quiz))
      end

      it "toggles the visibility" do
        visit quizzes_path
        expect { first("button").click }.to change{@quiz.reload.activated}.from(false).to(true)
        expect { first("button").click }.to change{@quiz.reload.activated}.from(true).to(false)
        current_path.should eq(quizzes_path)
      end
    end

    after(:all) do
      Quiz.destroy_all
    end
  end

  describe "destroy" do
    before(:all) do
      @quiz = create(:quiz, school: @school)
    end

    let(:quiz) { @quiz }

    it "redirects back after deletion" do
      visit quizzes_path
      expect { within(".controls") { all("a").last.click } }.to change{Quiz.count}.from(1).to(0)
      current_path.should eq(quizzes_path)
    end

    after(:all) do
      Quiz.destroy_all
    end
  end

  after(:all) do
    School.destroy_all
  end
end
