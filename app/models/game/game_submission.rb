# encoding: utf-8
require "active_attr"

class GameSubmission
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :players_count, type: Integer
  attribute :players, default: []
  attr_accessor :players_credentials

  validates_presence_of :quiz_id, message: "Nisi izabrao/la kviz."
  validates_presence_of :players_count, message: "Nisi izabrao/la broj igrača."
  validate :validate_authenticity_of_players

  def quiz
    @quiz ||= Quiz.find(quiz_id)
  end

  def info
    {
      quiz_id: quiz_id,
      question_ids: quiz.question_ids.shuffle,
      player_ids: players.map(&:id).shuffle
    }
  end

  private

  def validate_authenticity_of_players
    self.players += players_credentials
      .map { |attributes| Player.authenticate(attributes) }
      .reject { |player| !player }

    players.uniq!

    if players_count && players_count != players.count
      errors[:players_credentials] << "Pogrešno korisničko ime ili lozinka."
    end
  end
end
