# encoding: utf-8
require "spec_helper_full"

describe "Questions" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  context "from a school" do
    they "can be created" do
      visit school_questions_path(@school)
      click_on "Novo pitanje"
      click_on "Točno/netočno"

      fill_in "Tekst pitanja", with: "Question content"
      choose "Točno"
      expect { click_on "Stvori" }.to change{Question.count}.by 1

      current_path.should eq school_questions_path(@school)
      page.should have_content("Question content")
    end

    they "can be edited" do
      visit school_questions_path(@school)

      question = Question.first
      within(".item_controls") { first("a").click }

      current_path.should eq edit_school_question_path(@school, question)
      fill_in "Tekst pitanja", with: "Question content 2"
      click_on "Spremi"

      current_path.should eq school_questions_path(@school)
      question.reload.content.should eq "Question content 2"
    end

    they "can be deleted" do
      visit school_questions_path(@school)

      question = Question.first
      within(".item_controls") { all("a").last.click }

      current_path.should eq delete_school_question_path(@school, question)
      click_on "Nisam"

      current_path.should eq school_questions_path(@school)
      within(".item_controls") { all("a").last.click }
      expect { click_on "Jesam" }.to change{Question.count}.by -1

      current_path.should eq school_questions_path(@school)
    end
  end

  context "from everyone" do
    before(:all) {
      other_school = create(:other_school)
      quiz = create(:quiz, school: other_school)
      create(:question, school: other_school, quizzes: [quiz])
    }

    they "can be added to the school" do
      visit questions_path
      expect { click_on "Dodaj" }.to change{@school.questions.count}.by 1
      current_path.should eq questions_path
    end
  end

  after(:all) { @school.destroy }
end
