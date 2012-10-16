# encoding: utf-8
require "spec_helper_full"

describe "Questions" do
  before(:all) do
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  end

  before(:each) do
    login(:school, attributes_for(:school))
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

      category_labels = [
        "Točno/netočno",
        "Ponuđeni odgovori",
        "Asocijacija",
        "Pogodi tko/što je na slici",
        "Upiši točan odgovor"
      ]
      category_labels.each do |label|
        expect { click_on(label) }.to_not raise_error
        visit new_quiz_question_path(@quiz)
      end
    end

    def fill_in_the_form_incorrectly
      fill_in_the_form
      fill_in "Tekst pitanja", with: ""
    end

    describe "boolean" do
      let(:question) { build(:boolean_question) }

      def fill_in_the_form
        fill_in "Tekst pitanja", with: question.content
        choose "Točno"
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz, category: "boolean")

        fill_in_the_form_incorrectly
        expect { click_on "Stvori" }.to_not change{BooleanQuestion.count}

        current_path.should eq(quiz_questions_path(@quiz))
        find_field("Točno").should be_checked
      end

      it "redirects back to questions on success" do
        visit new_quiz_question_path(@quiz, category: "boolean")

        fill_in_the_form
        expect { click_on "Stvori" }.to change{BooleanQuestion.count}.by(1)

        current_path.should eq(quiz_questions_path(@quiz))
      end
    end

    describe "choice" do
      let(:question) { build(:choice_question) }

      def fill_in_the_form
        fill_in "Tekst pitanja", with: question.content
        (1..3).each do |n|
          fill_in "question_provided_answers_#{n}", with: question.provided_answers[n-1]
        end
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz, category: "choice")

        fill_in_the_form_incorrectly
        click_on "Stvori"

        (1..3).each do |n|
          find_field("question_provided_answers_#{n}").value.should eq(question.provided_answers[n-1])
        end

        all("li input").count.should eq 3
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "choice")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{ChoiceQuestion.count}.by(1)
      end
    end

    describe "association" do
      let(:question) { build(:association_question) }

      def fill_in_the_form
        fill_in "Tekst pitanja", with: question.content
        (1..3).each do |n|
          field_n = (n-1)*2 + 1
          fill_in "question_associations_#{field_n}", with: question.associations.keys[n-1]
          fill_in "question_associations_#{field_n + 1}", with: question.associations.values[n-1]
        end
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz)
        click_on "Asocijacija"

        fill_in_the_form_incorrectly
        click_on "Stvori"

        (1..3).each do |n|
          field_n = (n-1)*2 + 1
          find_field("question_associations_#{field_n}").value.should eq question.associations.keys[n-1]
          find_field("question_associations_#{field_n + 1}").value.should eq question.associations.values[n-1]
        end

        all("li input").count.should eq 6
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "association")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{AssociationQuestion.count}.by(1)
      end
    end

    describe "image" do
      let(:question) { build(:image_question) }

      def fill_in_the_form
        fill_in "Tekst pitanja", with: question.content
        attach_file "Slika", "#{Rails.root}/spec/fixtures/files/image.jpg"
        fill_in "Odgovor", with: question.answer
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz, category: "image")

        fill_in_the_form_incorrectly
        click_on "Stvori"

        find_field("Odgovor").value.should eq question.answer
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "image")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{ImageQuestion.count}.by(1)
      end
    end

    describe "text" do
      let(:question) { build(:text_question) }

      def fill_in_the_form
        fill_in "Tekst pitanja", with: question.content
        fill_in "Odgovor", with: question.answer
      end

      it "keeps the fields filled in on validation errors" do
        visit new_quiz_question_path(@quiz, category: "text")

        fill_in_the_form_incorrectly
        click_on "Stvori"

        find_field("Odgovor").value.should eq question.answer
      end

      it "is expected to be valid" do
        visit new_quiz_question_path(@quiz, category: "text")
        fill_in_the_form
        expect { click_on "Stvori" }.to change{TextQuestion.count}.by(1)
      end
    end

    after(:all) { Question.destroy_all }
  end

  describe "update" do
    before(:all) { @question = create(:boolean_question, quiz: @quiz) }

    it "redirects back to questions" do
      visit quiz_questions_path(@quiz)
      within(".controls") { first("a").click }
      click_on "Spremi"
      current_path.should eq(quiz_questions_path(@quiz))
    end

    after(:all) { @question.destroy }
  end

  describe "destroy" do
    before(:all) { @question = create(:question, quiz: @quiz) }

    it "has a link" do
      visit quiz_questions_path(@quiz)
      within(".controls") { all("a").last.click }
      current_path.should eq delete_quiz_question_path(@quiz, @question)
    end

    it "can be canceled" do
      visit delete_quiz_question_path(@quiz, @question)
      click_on "Nisam"
      current_path.should eq quiz_questions_path(@quiz)
    end

    it "can be confirmed" do
      visit delete_quiz_question_path(@quiz, @question)
      expect { click_on "Jesam" }.to change{Question.count}.by(-1)
      current_path.should eq quiz_questions_path(@quiz)
    end
  end

  after(:all) { @school.destroy }
end
