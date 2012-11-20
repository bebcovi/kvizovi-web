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
      within(".btn-group") { first("a").click }

      current_path.should eq edit_school_question_path(@school, question)
      fill_in "Tekst pitanja", with: "Question content 2"
      click_on "Spremi"

      current_path.should eq school_questions_path(@school)
      question.reload.content.should eq "Question content 2"
    end

    they "can be deleted" do
      visit school_questions_path(@school)

      question = Question.first
      within(".btn-group") { all("a").last.click }

      current_path.should eq delete_school_question_path(@school, question)
      click_on "Nisam"

      current_path.should eq school_questions_path(@school)
      within(".btn-group") { all("a").last.click }
      expect { click_on "Jesam" }.to change{Question.count}.by -1

      current_path.should eq school_questions_path(@school)
    end

    they "can be copied" do
      pending
    end
  end

  context "from everyone" do
    before(:all) {
      @other_school = create(:other_school)
      create(:question, school: @other_school)
    }

    they "aren't displayed if they belong to the logged in school" do
      question1 = create(:question, content: "Question 1", school: @school)
      question2 = create(:question, content: "Question 2", school: @other_school)
      visit questions_path

      page.should have_content(question2.content)
      page.should_not have_content(question1.content)

      [question1, question2].each(&:destroy)
    end

    they "can be copied" do
      visit questions_path
      within(".btn-group") { all("a").first.click }

      click_on "Natrag"
      current_path.should eq questions_path

      within(".btn-group") { all("a").first.click }
      click_on "Kopiraj"

      expect { click_on "Stvori" }.to change{@school.questions.count}.by 1
      current_path.should eq questions_path
    end

    after(:all) { @other_school.destroy }
  end

  after(:all) { @school.destroy }
end
