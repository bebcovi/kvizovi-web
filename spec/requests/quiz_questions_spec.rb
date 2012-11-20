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
    within(".btn-group") { all("a").first.click }
    current_path.should eq quiz_questions_path(@quiz)
  end

  context "when creating a question" do
    describe "boolean" do
      it "has a link for it" do
        visit quiz_questions_path(@quiz)
        find(%(a[href="#{new_quiz_question_path(@quiz, category: "boolean")}"])).click
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "boolean")
          expect { click_on "Stvori" }.to_not change{@quiz.boolean_questions.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:boolean_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "boolean")

          fill_in "Tekst pitanja", with: attributes[:content]
          choose "Točno"

          expect { click_on "Stvori" }.to change{@quiz.boolean_questions.count}.by 1
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "choice" do
      it "has a link for it" do
        visit quiz_questions_path(@quiz)
        find(%(a[href="#{new_quiz_question_path(@quiz, category: "choice")}"])).click
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "choice")
          expect { click_on "Stvori" }.to_not change{@quiz.choice_questions.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:choice_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "choice")

          fill_in "Tekst pitanja", with: attributes[:content]
          (1..3).each { |n| fill_in "question_provided_answers_#{n}", with: attributes[:provided_answers][n-1] }

          expect { click_on "Stvori" }.to change{@quiz.choice_questions.count}.by 1
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "association" do
      it "has a link for it" do
        visit quiz_questions_path(@quiz)
        find(%(a[href="#{new_quiz_question_path(@quiz, category: "association")}"])).click
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "association")
          expect { click_on "Stvori" }.to_not change{@quiz.association_questions.count}
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

          expect { click_on "Stvori" }.to change{@quiz.association_questions.count}.by 1
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "image" do
      let(:attributes) { attributes_for(:image_question) }

      it "has a link for it" do
        visit quiz_questions_path(@quiz)
        find(%(a[href="#{new_quiz_question_path(@quiz, category: "image")}"])).click
      end

      describe "uploading from URL" do
        before(:each) do
          visit new_quiz_question_path(@quiz, category: "image")
          fill_in "Tekst pitanja", with: attributes[:content]
          fill_in "Odgovor", with: attributes[:answer]
        end

        it "can be done" do
          fill_in "URL od slike", with: "http://2.bp.blogspot.com/-pZQCOrLJWI0/TcvM0X_mjOI/AAAAAAAADQI/UcxDKSzseBg/s640/Cool+Images+by+cool+images786+%25283%2529.jpg"
          expect { click_on "Stvori" }.to change{@quiz.image_questions.count}.by 1
        end

        it "shows validation errors when URL is invalid" do
          fill_in "URL od slike", with: "http://invalid-url"
          expect { click_on "Stvori" }.to_not change{@quiz.image_questions.count}
        end
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "image")
          expect { click_on "Stvori" }.to_not change{@quiz.image_questions.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "image")

          fill_in "Tekst pitanja", with: attributes[:content]
          attach_file "Slika", "#{Rails.root}/spec/fixtures/files/image.jpg"
          fill_in "Odgovor", with: attributes[:answer]

          expect { click_on "Stvori" }.to change{@quiz.image_questions.count}.by 1
          current_path.should eq quiz_questions_path(@quiz)
        end
      end
    end

    describe "text" do
      it "has a link for it" do
        visit quiz_questions_path(@quiz)
        find(%(a[href="#{new_quiz_question_path(@quiz, category: "text")}"])).click
      end

      context "on validation errors" do
        it "is held on the same page" do
          visit new_quiz_question_path(@quiz, category: "text")
          expect { click_on "Stvori" }.to_not change{@quiz.text_questions.count}
          current_path.should eq quiz_questions_path(@quiz)
        end
      end

      context "on success" do
        let(:attributes) { attributes_for(:text_question) }

        it "gets redirected back to questions" do
          visit new_quiz_question_path(@quiz, category: "text")

          fill_in "Tekst pitanja", with: attributes[:content]
          fill_in "Odgovor", with: attributes[:answer]

          expect { click_on "Stvori" }.to change{@quiz.text_questions.count}.by(1)
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
      within(".btn-group") { first("a").click }
      click_on "Spremi"
      current_path.should eq quiz_questions_path(@quiz)
    end

    after(:all) { @question.destroy }
  end

  context "when destroying questions" do
    before(:all) { @question = create(:question, school: @school, quizzes: [@quiz]) }

    it "has the link for it" do
      visit quiz_questions_path(@quiz)
      within(".btn-group") { all("a").last.click }
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
