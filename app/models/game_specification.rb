require "active_attr"

class GameSpecification
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :players_count, type: Integer
  attribute :players_credentials, default: []

  validates :quiz_id,        presence: true
  validates :players_count, presence: true
  validate :validate_authenticity_of_players

  def players
    @players ||= []
  end

  def quiz
    @quiz ||= Quiz.find(quiz_id)
  end

  private

  def validate_authenticity_of_players
    players_credentials
      .map { |attributes| authenticate(attributes) }
      .each { |player| players << player unless player.blank? }

    if players_count != players.count
      errors.add(:players_credentials, :invalid)
    end
  end

  def authenticate(attrs)
    student = Student.find_by(username: attrs[:username])
    student.try(:authenticate, attrs[:password])
  end
end
