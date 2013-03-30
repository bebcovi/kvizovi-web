# encoding: utf-8
require "active_attr"

class GameSubmission
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :players_count, type: Integer
  attribute :players_credentials, default: []
  attribute :player_class

  attr_writer :players
  def players
    @players ||= []
  end

  validates_presence_of :quiz_id, message: "Nisi izabrao/la kviz."
  validates_presence_of :players_count, message: "Nisi izabrao/la broj igrača."
  validate :validate_authenticity_of_players
  validate :validate_uniqueness_of_players

  def quiz
    @quiz ||= Quiz.find(quiz_id) if quiz_id
  end

  def info
    question_ids = quiz.question_ids.shuffle
    question_ids.pop if players.count.even? and quiz.questions.count.odd?
    player_ids = players.map(&:id)

    {
      quiz_id:      quiz_id,
      question_ids: question_ids,
      player_ids:   player_ids,
      clock:        Time
    }
  end

  private

  def validate_authenticity_of_players
    self.players += players_credentials
      .map { |attributes| UserAuthenticator.new(player_class).authenticate(attributes[:username], attributes[:password]) }
      .reject { |player| !player }

    if players_count && players_count != players.count
      errors[:players_credentials] << "Pogrešno korisničko ime ili lozinka."
    end
  end

  def validate_uniqueness_of_players
    if players != players.uniq
      errors[:players_credentials] << "Drugi igrač mora biti netko drugi osim trenutno prijavljeni igrač."
    end
  end
end
