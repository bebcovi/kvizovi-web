# encoding: utf-8
require "spec_helper"

describe "Questions" do
  before(:all) do
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  end

  before(:each) do
    login(@school)
  end

  it "has a link" do
    visit quizzes_path
    within(".controls") { all("a").second[:href].should eq(quiz_questions_path(@quiz)) }
  end

  describe "create" do
    it "has a link" do
      visit quiz_questions_path(@quiz)
      find_link("Novo pitanje")[:href].should eq(new_quiz_question_path(@quiz))
    end

    it "first asks for the category" do
      visit new_quiz_question_path(@quiz)
      all("form").should be_empty
    end

    it "already has the points selected" do
      visit new_quiz_question_path(@quiz, category: "boolean")
      find_field("1").should be_checked
    end

    describe "boolean" do
      let(:question) { build_stubbed(:boolean_question) }

      def fill_in_the_form
        fill_in "Tvrdnja", with: question.content
        choose "Točno"
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz)
        click_on "Točno/netočno"

        fill_in_the_form
        fill_in "Tvrdnja", with: ""
        click_on "Stvori"

        current_path.should eq(quiz_questions_path(@quiz))
        find_field("Točno").should be_checked
      end

      it "redirects back to questions on success" do
        visit new_quiz_question_path(@quiz, category: "boolean")

        fill_in_the_form
        expect { click_on "Stvori" }.to change{Question.count}.from(0).to(1)

        current_path.should eq(quiz_questions_path(@quiz))
        page.should have_content("Pitanje je stvoreno.")
      end

      after(:all) do
        Question.destroy_all
      end
    end

    describe "choice" do
      let(:question) { build_stubbed(:choice_question) }

      def fill_in_the_form
        fill_in "Pitanje", with: question.content
        fill_in "question_data_1", with: "Foo"
        fill_in "question_data_2", with: "Bar"
        fill_in "question_data_3", with: "Baz"
        fill_in "question_data_4", with: "Bla"
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz)
        click_on "4 ponuđena odgovora"

        fill_in_the_form
        fill_in "Pitanje", with: ""
        click_on "Stvori"

        find_field("question_data_1").value.should eq("Foo")
        find_field("question_data_2").value.should eq("Bar")
        find_field("question_data_3").value.should eq("Baz")
        find_field("question_data_4").value.should eq("Bla")
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "choice")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{Question.count}.from(0).to(1)
      end

      after(:all) do
        Question.destroy_all
      end
    end

    describe "association" do
      let(:question) { build_stubbed(:association_question) }

      def fill_in_the_form
        fill_in "Pitanje", with: question.content
        fill_in "question_data_1", with: "Foo"
        fill_in "question_data_2", with: "Foo"
        fill_in "question_data_3", with: "Bar"
        fill_in "question_data_4", with: "Bar"
        fill_in "question_data_5", with: "Baz"
        fill_in "question_data_6", with: "Baz"
        fill_in "question_data_7", with: "Bla"
        fill_in "question_data_8", with: "Bla"
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz)
        click_on "Asocijacija"

        fill_in_the_form
        fill_in "Pitanje", with: ""
        click_on "Stvori"

        find_field("question_data_1").value.should eq("Foo")
        find_field("question_data_2").value.should eq("Foo")
        find_field("question_data_3").value.should eq("Bar")
        find_field("question_data_4").value.should eq("Bar")
        find_field("question_data_5").value.should eq("Baz")
        find_field("question_data_6").value.should eq("Baz")
        find_field("question_data_7").value.should eq("Bla")
        find_field("question_data_8").value.should eq("Bla")
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "association")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{Question.count}.from(0).to(1)
      end

      after(:all) do
        Question.destroy_all
      end
    end

    describe "photo" do
      let(:question) { build_stubbed(:photo_question) }

      def fill_in_the_form
        fill_in "Pitanje", with: question.content
        attach_file "Slika", "#{Rails.root}/spec/fixtures/files/photo.jpg"
        fill_in "Odgovor", with: question.data
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz)
        click_on "Pogodi tko/što je na slici"

        fill_in_the_form
        fill_in "Pitanje", with: ""
        click_on "Stvori"

        find_field("Odgovor").value.should eq(question.data)
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "photo")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{Question.count}.from(0).to(1)
      end

      after(:all) do
        Question.destroy_all
      end
    end

    describe "text" do
      let(:question) { build_stubbed(:text_question) }

      def fill_in_the_form
        fill_in "Pitanje", with: question.content
        fill_in "Odgovor", with: question.data
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz)
        click_on "Upiši točan odgovor"

        fill_in_the_form
        fill_in "Pitanje", with: ""
        click_on "Stvori"

        find_field("Odgovor").value.should eq(question.data)
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "text")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{Question.count}.from(0).to(1)
      end

      after(:all) do
        Question.destroy_all
      end
    end
  end

  describe "update" do
    before(:all) { @question = create(:question, quiz: @quiz) }

    it "redirects back to questions" do
      visit quiz_questions_path(@quiz)
      within(".controls") { first("a").click }
      click_on "Spremi"
      current_path.should eq(quiz_questions_path(@quiz))
    end

    after(:all) { Question.destroy_all }
  end

  describe "delete" do
    before(:all) { @question = create(:question, quiz: @quiz) }

    it "redirects back to questions" do
      visit quiz_questions_path(@quiz)
      expect { within(".controls") { all("a").last.click } }.to change{Question.count}.from(1).to(0)
      current_path.should eq(quiz_questions_path(@quiz))
      page.should have_content("Pitanje je izbrisano.")
    end

    after(:all) { Question.destroy_all }
  end

  after(:all) do
    School.destroy_all
  end
end
