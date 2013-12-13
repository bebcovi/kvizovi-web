require "spec_helper"

describe Quiz do
  subject { described_class.new }

  describe ".search" do
    it "searches quiz name" do
      quiz = create(:quiz, name: "Quiz name")
      expect(described_class.search("Quiz name")).to include(quiz)
    end

    it "searches questions content" do
      quiz = create(:quiz, questions: [
        create(:text_question, content: "Question content", answer: "Question data")
      ])

      expect(described_class.search("Question content")).to include(quiz)
      expect(described_class.search("Question data")).to include(quiz)
    end

    it "ranks quiz' name higher than questions' content/data" do
      quiz1 = create(:quiz, questions: [create(:text_question, content: "Query")])
      quiz2 = create(:quiz, name: "Query")

      expect(described_class.search("Query")).to eq [quiz2, quiz1]
    end

    it "ranks question's content higher than question's data" do
      quiz1 = create(:quiz, questions: [create(:text_question, answer: "Query")])
      quiz2 = create(:quiz, questions: [create(:text_question, content: "Query")])

      expect(described_class.search("Query")).to eq [quiz2, quiz1]
    end

    it "ranks more occurences higher" do
      quiz1 = create(:quiz, questions: [create(:question, content: "Query")])
      quiz2 = create(:quiz, questions: create_list(:question, 2, content: "Query"))

      expect(described_class.search("Query")).to eq [quiz2, quiz1]
    end

    it "ignores accents" do
      quiz = create(:quiz, name: "Qüery")

      expect(described_class.search("Query")).to include(quiz)
      expect(described_class.search("Querý")).to include(quiz)
    end

    it "searches parts of words" do
      quiz = create(:quiz, name: "Query")

      expect(described_class.search("Quer")).to include(quiz)
    end

    it "does basic stemming" do
      quiz = create(:quiz, name: "Antigone")

      expect(described_class.search("Antigona")).to include(quiz)
    end

    it "searches by keywords" do
      quiz = create(:quiz, name: "Foo", questions: [create(:question, content: "Bar")])

      expect(described_class.search("Foo Bar")).to include(quiz)
    end

    it "is case insensitive" do
      quiz = create(:quiz, name: "Query")
      expect(described_class.search("query")).to include(quiz)
    end
  end

  describe "#name" do
    it "must be present" do
      subject.name = nil
      expect(subject).to have(1).error_on(:name)
    end

    it "must be unique inside a school" do
      create(:quiz, name: "Foo", school_id: 1)
      subject.assign_attributes(name: "Foo", school_id: 1)
      expect(subject).to have(1).error_on(:name)
    end
  end
end
