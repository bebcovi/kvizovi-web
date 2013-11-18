require "spec_helper"

describe QuizSnapshot do
  subject { described_class.capture(quiz) }
  let(:quiz) { create(:quiz) }

  describe "#quiz" do
    let(:quiz) { create(:quiz, name: "Quiz", activated: true) }

    it "instantiates the quiz from the attributes" do
      quiz = subject.quiz

      expect(quiz).to be_a(Quiz)
      expect(quiz.name).to eq "Quiz"
      expect(quiz.activated).to eq true
    end
  end

  describe "#questions" do
    before { quiz.questions << create(:boolean_question, content: "Content", answer: true) }

    it "instantiates the questions from the attributes" do
      question = subject.questions.first

      expect(question).to be_a(BooleanQuestion)
      expect(question.content).to eq "Content"
      expect(question.answer).to eq true
    end
  end
end
