# encoding: utf-8
require "spec_helper_full"

describe "Creating questions" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  it "redirects back to questions on success" do
    visit new_school_question_path(@school, category: "boolean")

    fill_in "Tekst pitanja", with: "Content"
    choose "Točno"
    click_on "Stvori"

    current_path.should eq school_questions_path(@school)
  end

  it "stays on the same page on validation errors" do
    visit new_school_question_path(@school, category: "boolean")
    click_on "Stvori"
    page.should have_css("form#new_question")
  end

  context "boolean" do
    let(:attributes) { attributes_for(:boolean_question) }

    it "has a link" do
      visit school_questions_path(@school)
      within(".new_question .dropdown-menu") { all("a")[0].click }
      current_url.should eq new_school_question_url(@school, category: "boolean")
    end

    it "isn't valid when the answer is not chosen" do
      visit new_school_question_path(@school, category: "boolean")
      fill_in "Tekst pitanja", with: attributes[:content]
      expect { click_on "Stvori" }.to_not change{@school.boolean_questions.count}
    end

    it "is expected to be valid" do
      visit new_school_question_path(@school, category: "boolean")

      fill_in "Tekst pitanja", with: attributes[:content]
      choose "Točno"

      expect { click_on "Stvori" }.to change{@school.boolean_questions.count}.by 1
    end
  end

  context "choice" do
    let(:attributes) { attributes_for(:choice_question) }

    it "has a link for it" do
      visit school_questions_path(@school)
      within(".new_question .dropdown-menu") { all("a")[1].click }
      current_url.should eq new_school_question_url(@school, category: "choice")
    end

    it "isn't valid when the first provided answer isn't filled in" do
      visit new_school_question_path(@school, category: "choice")
      fill_in "Tekst pitanja", with: attributes[:content]
      expect { click_on "Stvori" }.to_not change{@school.choice_questions.count}
    end

    it "is expected to be valid" do
      visit new_school_question_path(@school, category: "choice")

      fill_in "Tekst pitanja", with: attributes[:content]
      attributes[:provided_answers].count.times { |idx|
        fill_in "question_provided_answers_#{idx + 1}", with: attributes[:provided_answers][idx]
      }

      expect { click_on "Stvori" }.to change{@school.choice_questions.count}.by 1
    end
  end

  context "association" do
    let(:attributes) { attributes_for(:association_question) }

    it "has a link for it" do
      visit school_questions_path(@school)
      within(".new_question .dropdown-menu") { all("a")[2].click }
      current_url.should eq new_school_question_url(@school, category: "association")
    end

    it "isn't valid when one pair is not filled in" do
      visit new_school_question_path(@school, category: "association")
      fill_in "Tekst pitanja", with: attributes[:content]
      fill_in "question_associations_1", with: attributes[:associations].to_a.flatten.first
      expect { click_on "Stvori" }.to_not change{@school.association_questions.count}
    end

    it "is expected to be valid" do
      visit new_school_question_path(@school, category: "association")

      fill_in "Tekst pitanja", with: attributes[:content]
      attributes[:associations].count.times do |idx|
        fill_in "question_associations_#{idx*2 + 1}", with: attributes[:associations].keys[idx]
        fill_in "question_associations_#{idx*2 + 2}", with: attributes[:associations].values[idx]
      end

      expect { click_on "Stvori" }.to change{@school.association_questions.count}.by 1
    end
  end

  describe "image" do
    let(:attributes) { attributes_for(:image_question) }

    it "has a link for it" do
      visit school_questions_path(@school)
      within(".new_question .dropdown-menu") { all("a")[3].click }
      current_url.should eq new_school_question_url(@school, category: "image")
    end

    describe "uploading from URL" do
      before(:each) do
        visit new_school_question_path(@school, category: "image")
        fill_in "Tekst pitanja", with: attributes[:content]
        fill_in "Odgovor", with: attributes[:answer]
      end

      it "can be done" do
        fill_in "URL od slike", with: "http://2.bp.blogspot.com/-pZQCOrLJWI0/TcvM0X_mjOI/AAAAAAAADQI/UcxDKSzseBg/s640/Cool+Images+by+cool+images786+%25283%2529.jpg"
        expect { click_on "Stvori" }.to change{@school.image_questions.count}.by 1
      end

      it "isn't valid when the URL isn't invalid" do
        fill_in "URL od slike", with: "http://invalid-url"
        expect { click_on "Stvori" }.to_not change{@school.image_questions.count}
      end
    end

    it "is expected to be valid" do
      visit new_school_question_path(@school, category: "image")

      fill_in "Tekst pitanja", with: attributes[:content]
      attach_file "Slika", "#{Rails.root}/spec/fixtures/files/image.jpg"
      fill_in "Odgovor", with: attributes[:answer]

      expect { click_on "Stvori" }.to change{@school.image_questions.count}.by 1
    end
  end

  describe "text" do
    let(:attributes) { attributes_for(:image_question) }

    it "has a link for it" do
      visit school_questions_path(@school)
      within(".new_question .dropdown-menu") { all("a")[4].click }
      current_url.should eq new_school_question_url(@school, category: "text")
    end

    it "is expected to be valid" do
      visit new_school_question_path(@school, category: "text")

      fill_in "Tekst pitanja", with: attributes[:content]
      fill_in "Odgovor", with: attributes[:answer]

      expect { click_on "Stvori" }.to change{@school.text_questions.count}.by(1)
    end
  end

  it "can be done inside a quiz" do
    quiz = create(:quiz, school: @school)
    visit quiz_questions_path(quiz)

    find(%(a[href="#{new_quiz_question_path(quiz, category: "boolean")}"])).click
    fill_in "Tekst pitanja", with: "Content"
    choose "Točno"
    expect { click_on "Stvori" }.to change{quiz.questions.count}.by 1

    current_path.should eq quiz_questions_path(quiz)
  end

  after(:all) { @school.destroy }
end
