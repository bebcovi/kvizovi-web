require "spec_helper"
require "kvizovi/mediators/gameplays"

RSpec.describe Kvizovi::Mediators::Gameplays do
  subject { described_class.new(user) }
  let(:user) { create(:janko) }
  let(:quiz) { create(:quiz, creator_id: user.id) }

  describe ".create" do
    it "creates the gameplay" do
      gameplay = described_class.create(
        attributes_for(:gameplay,
          links: {
            quiz: {linkage: {type: :quizzes, id: quiz.id}},
            players: {linkage: [{type: :users, id: user.id}]},
          }
        )
      )

      expect(gameplay).to exist
      expect(gameplay.quiz).to eq quiz
      expect(gameplay.players).to eq [user]
    end
  end

  describe "#search" do
    let!(:gameplay) { create(:gameplay, quiz_id: quiz.id, player_ids: [user.id]) }

    it "returns gameplays of quizzes the user created" do
      create(:quiz)

      gameplays = subject.search(as: "creator")
      expect(gameplays.to_a).to eq [gameplay]

      gameplays = subject.search(as: "creator", quiz_id: quiz.id + 1)
      expect(gameplays.to_a).to eq []
    end

    it "returns gameplays of quizzes the user played" do
      create(:quiz)

      gameplays = subject.search(as: "player")
      expect(gameplays.to_a).to eq [gameplay]

      gameplays = subject.search(as: "player", quiz_id: quiz.id + 1)
      expect(gameplays.to_a).to eq []
    end

    it "paginates results" do
      create(:gameplay, quiz_id: quiz.id, player_ids: [user.id])

      gameplays = subject.search(as: "creator", page: {number: 1, size: 1})
      expect(gameplays.count).to eq 1

      gameplays = subject.search(as: "creator", page: {number: 1, size: 2})
      expect(gameplays.count).to eq 2
    end
  end

  describe "#find" do
    let(:gameplay) { create(:gameplay) }

    it "returns gameplay with the given ID" do
      expect(subject.find(gameplay.id)).to eq gameplay
    end
  end
end
