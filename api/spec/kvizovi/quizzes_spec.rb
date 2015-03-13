require "spec_helper"
require "kvizovi/quizzes"
require "kvizovi/models/user"

RSpec.describe Kvizovi::Quizzes do
  subject { Kvizovi::Quizzes.new(user) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe "#all" do
    it "returns all quizzes sorted by most recently updated" do
      quiz_after = subject.create(attributes_for(:quiz))
      quiz_before = subject.create(attributes_for(:quiz))
      quiz_before.update(updated_at: Time.now - 60)
      another_quiz = create(:quiz)

      expect(subject.all.to_a).to eq [quiz_before, quiz_after]
    end
  end

  describe "#create" do
    it "creates a quiz with questions" do
      quiz = subject.create(attributes_for(:quiz, questions_attributes: [
        attributes_for(:boolean_question),
        attributes_for(:choice_question),
        attributes_for(:association_question),
        attributes_for(:text_question),
      ]))

      expect(quiz.questions.count).to eq 4
      expect(quiz.creator).to eq user
    end

    it "controls mass assignment" do
      expect { subject.create(created_at: Time.now) }
        .to raise_error(Sequel::Error)
    end
  end

  describe "#find" do
    it "finds the quiz with the given id" do
      quiz = subject.create(attributes_for(:quiz))

      expect(subject.find(quiz.id)).to eq quiz
    end

    it "doesn't find quizzes from another user" do
      quizzes = Kvizovi::Quizzes.new(another_user)
      quiz = quizzes.create(attributes_for(:quiz))

      expect { subject.find(quiz.id) }.to raise_error
    end
  end

  describe "#update" do
    it "updates the quiz" do
      quiz = subject.create(attributes_for(:quiz))

      quiz = subject.update(quiz.id, {name: "New name"})

      expect(quiz.name).to eq "New name"
    end

    it "controls mass assignment" do
      quiz = subject.create(attributes_for(:quiz))
      expect { subject.update(quiz.id, created_at: Time.now) }
        .to raise_error(Sequel::Error)
    end

    it "doesn't find quizzes from another user" do
      quizzes = Kvizovi::Quizzes.new(another_user)
      quiz = quizzes.create(attributes_for(:quiz))

      expect { subject.update(quiz.id, {}) }.to raise_error
    end
  end

  describe "#destroy" do
    it "destroys the quiz" do
      quiz = subject.create(attributes_for(:quiz))

      subject.destroy(quiz.id)

      expect(quiz).not_to exist
    end

    it "destroys the associated questions" do
      quiz = subject.create(attributes_for(:quiz, questions_attributes: [
        attributes_for(:question),
      ]))

      subject.destroy(quiz.id)

      expect(DB[:questions]).to be_empty
    end

    it "doesn't find quizzes from another user" do
      quizzes = Kvizovi::Quizzes.new(another_user)
      quiz = quizzes.create(attributes_for(:quiz))

      expect { subject.destroy(quiz.id) }.to raise_error
    end
  end
end
