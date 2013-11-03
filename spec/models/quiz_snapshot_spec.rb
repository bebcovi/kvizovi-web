require "spec_helper"

describe QuizSnapshot do
  subject { described_class.capture(quiz_specification) }
  let(:quiz_specification) { double(quiz: quiz, students: students) }
  let(:quiz) { create(:quiz) }
  let(:students) { [double] }

  describe ".capture" do
    let(:students) { [double, double] }

    it "trims the number of questions to be divisible by the number of students" do
      quiz.questions = create_list(:question, 4)
      subject = described_class.capture(quiz_specification)
      expect(subject.questions.count).to eq 4

      quiz.questions = create_list(:question, 5)
      subject = described_class.capture(quiz_specification)
      expect(subject.questions.count).to eq 4
    end
  end

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
