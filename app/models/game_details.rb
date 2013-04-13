require "active_attr"

class GameDetails
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :players_count, type: Integer
  attribute :players_credentials, default: []

  validates :quiz_id,       presence: true
  validates :players_count, presence: true
  validate :validate_authenticity_of_players

  attr_writer :player_class

  attr_writer :players
  def players
    @players ||= []
  end

  def quiz
    @quiz ||= Quiz.find(quiz_id) if quiz_id
  end

  def to_h
    question_ids = quiz.question_ids
    question_ids.shuffle! if quiz.shuffle_questions?
    player_ids = players.map(&:id)
    question_ids.pop until question_ids.count % player_ids.count == 0

    {
      quiz_id:      quiz_id,
      question_ids: question_ids,
      player_ids:   player_ids,
    }
  end

  private

  def validate_authenticity_of_players
    self.players += players_credentials
      .map { |attr| authenticator.authenticate(attr[:username], attr[:password]) }
      .reject(&:blank?)

    if players_count && players_count != players.count
      errors.add(:players_credentials, :invalid)
    end
  end

  def authenticator
    UserAuthenticator.new(@player_class)
  end
end
