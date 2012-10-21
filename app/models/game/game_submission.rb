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
    @quiz ||= Quiz.find(quiz_id)
  end

  def info
    grouped_questions = quiz.questions.group_by(&:category)
    groups = grouped_questions.keys
    question_ids = []
    until groups.empty?
      random_group = groups.sample
      players_count.times do
        random_question = grouped_questions[random_group].sample
        grouped_questions[random_group].delete(random_question)
        question_ids << random_question.id
      end
      groups.delete(random_group) if grouped_questions[random_group].empty?
    end

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
      .map { |attributes| player_class.authenticate(attributes) }
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
