# encoding: utf-8
require "spec_helper_full"

describe "School" do
  before(:all) {
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
  }

  before(:each) { login(:school, attributes_for(:school)) }

  it "has a link for managing questions from a quiz" do
    visit quizzes_path
    within(".item_controls") { all("a").second.click }
    current_path.should eq quiz_questions_path(@quiz)
  end

  context "when creating a question" do
    it "has the link for it" do
      visit quiz_questions_path(@quiz)
      click_on "Novo pitanje"
      current_path.should eq new_quiz_question_path(@quiz)
    end

    it "first asks for the category" do
      visit new_quiz_question_path(@quiz)

      category_labels = [
        "Točno/netočno",
        "Ponuđeni odgovori",
        "Asocijacija",
        "Pogodi tko/što je na slici",
        "Upiši točan odgovor"
      ]
      category_labels.each do |label|
        click_on(label)
        visit new_quiz_question_path(@quiz)
      end
    end

    describe "boolean" do
      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "boolean")
          expect { click_on "Stvori" }.to_not change{BooleanQuestion.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:boolean_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "boolean")

          fill_in "Tekst pitanja", with: attributes[:content]
          choose "Točno"

          expect { click_on "Stvori" }.to change{BooleanQuestion.count}.by(1)
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "choice" do
      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "choice")
          expect { click_on "Stvori" }.to_not change{ChoiceQuestion.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:choice_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "choice")

          fill_in "Tekst pitanja", with: attributes[:content]
          (1..3).each { |n| fill_in "question_provided_answers_#{n}", with: attributes[:provided_answers][n-1] }

          expect { click_on "Stvori" }.to change{ChoiceQuestion.count}.by(1)
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "association" do
      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "association")
          expect { click_on "Stvori" }.to_not change{AssociationQuestion.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:association_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "association")

          fill_in "Tekst pitanja", with: attributes[:content]
          (1..3).each do |n|
            field_n = (n-1)*2 + 1
            fill_in "question_associations_#{field_n}", with: attributes[:associations].keys[n-1]
            fill_in "question_associations_#{field_n + 1}", with: attributes[:associations].values[n-1]
          end

          expect { click_on "Stvori" }.to change{AssociationQuestion.count}.by(1)
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "image" do
      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "image")
          expect { click_on "Stvori" }.to_not change{ImageQuestion.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:image_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "image")

          fill_in "Tekst pitanja", with: attributes[:content]
          attach_file "Slika", "#{Rails.root}/spec/fixtures/files/image.jpg"
          fill_in "Odgovor", with: attributes[:answer]

          expect { click_on "Stvori" }.to change{ImageQuestion.count}.by(1)
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "text" do
      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "text")
          expect { click_on "Stvori" }.to_not change{TextQuestion.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:text_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "text")

          fill_in "Tekst pitanja", with: attributes[:content]
          fill_in "Odgovor", with: attributes[:answer]

          expect { click_on "Stvori" }.to change{TextQuestion.count}.by(1)
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    after(:all) { Question.destroy_all }
  end

  context "when updating questions" do
    before(:all) { @question = create(:question, school: @school, quizzes: [@quiz]) }

    it "gets redirected back to questions" do
      visit quiz_questions_path(@quiz)
      within(".item_controls") { first("a").click }
      click_on "Spremi"
      current_path.should eq quiz_questions_path(@quiz)
    end

    after(:all) { @question.destroy }
  end

  context "when destroying questions" do
    before(:all) { @question = create(:question, school: @school, quizzes: [@quiz]) }

    it "has the link for it" do
      visit quiz_questions_path(@quiz)
      within(".item_controls") { all("a").last.click }
      current_path.should eq delete_quiz_question_path(@quiz, @question)
    end

    it "can cancel it" do
      visit delete_quiz_question_path(@quiz, @question)
      click_on "Nisam"
      current_path.should eq quiz_questions_path(@quiz)
    end

    it "can confirm it" do
      visit delete_quiz_question_path(@quiz, @question)
      expect { click_on "Jesam" }.to change{Question.count}.by(-1)
      current_path.should eq quiz_questions_path(@quiz)
    end
  end

  after(:all) {
    @quiz.destroy
    @school.destroy
  }
end
