require 'spec_helper'

describe Question do
  describe "validations" do
    it "needs #content" do
      question = build(:question, content: nil)
      question.should_not be_valid
      question = build(:question)
      question.should be_valid
    end

    context "boolean question" do
      it "needs the correct answer" do
        question = build(:boolean_question, data: nil)
        question.should_not be_valid
        question = build(:boolean_question)
        question.should be_valid
      end
    end

    context "choice question" do
      it "needs all provided answers" do
        question = build(:choice_question, data: ["Foo", "Bar", ""])
        question.should_not be_valid
        question = build(:choice_question)
        question.should be_valid
      end
    end

    context "association question" do
      it "needs all provided answers on both sides" do
        question = build(:association_question, data: ["Foo", "Bar", "", "Foo", "Bar", "Baz"])
        question.should_not be_valid
        question = build(:association_question, data: ["Foo", "Bar", "Baz", "Foo", "Bar", ""])
        question.should_not be_valid
        question = build(:association_question)
        question.should be_valid
      end
    end

    context "photo question" do
      it "needs a photo and the correct answer" do
        question = build(:photo_question, attachment: nil)
        question.should_not be_valid
        question = build(:photo_question, data: nil)
        question.should_not be_valid
        question = build(:photo_question)
        question.should be_valid
      end
    end

    context "text question" do
      it "needs the correct answer" do
        question = build(:text_question, data: nil)
        question.should_not be_valid
        question = build(:text_question)
        question.should be_valid
      end
    end
  end

  describe "methods" do
    it "is not case sensitive when accepting answers" do
      question = build(:photo_question, data: "Answer")
      question.correct_answer?("answer").should be_true
      question = build(:text_question, data: "Answer")
      question.correct_answer?("answer").should be_true
    end
  end
end
