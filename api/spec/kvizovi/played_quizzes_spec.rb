require "spec_helper"
require "kvizovi/played_quizzes"

RSpec.describe Kvizovi::PlayedQuizzes do
  subject { Kvizovi::PlayedQuizzes.new(user) }
  let!(:user) { create(:janko) }
  let!(:quiz) { create(:quiz, creator_id: user.id) }

  describe ".create" do
    it "creates the played quiz" do
      played_quiz = described_class.create(
        attributes_for(:played_quiz, quiz_id: quiz.id), [user])

      expect(played_quiz).to exist
    end
  end

  describe "#search" do
    let!(:played_quiz) { create(:played_quiz, quiz_id: quiz.id, player_ids: [user.id]) }

    it "returns played quizzes of quizzes the user created" do
      create(:quiz)

      played_quizzes = subject.search(as: "creator")
      expect(played_quizzes.to_a).to eq [played_quiz]

      played_quizzes = subject.search(as: "creator", quiz_id: quiz.id + 1)
      expect(played_quizzes.to_a).to eq []
    end

    it "returns played quizzes of quizzes the user played" do
      create(:quiz)

      played_quizzes = subject.search(as: "player")
      expect(played_quizzes.to_a).to eq [played_quiz]

      played_quizzes = subject.search(as: "player", quiz_id: quiz.id + 1)
      expect(played_quizzes.to_a).to eq []
    end

    it "paginates results" do
      create(:played_quiz, quiz_id: quiz.id, player_ids: [user.id])

      played_quizzes = subject.search(as: "creator", per_page: 1)
      expect(played_quizzes.count).to eq 1

      played_quizzes = subject.search(as: "creator", per_page: 2)
      expect(played_quizzes.count).to eq 2
    end
  end
end
