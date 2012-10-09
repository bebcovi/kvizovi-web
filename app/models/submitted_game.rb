# encoding: utf-8

class SubmittedGame
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :players_count, type: Integer
  attribute :players, default: []
  attr_accessor :players_credentials

  validates_presence_of :quiz_id, message: "Nisi izabrao/la kviz."
  validates_presence_of :players_count, message: "Nisi izabrao/la broj igrača."
  validate :all_players_should_be_authenticated

  def quiz
    Quiz.find(quiz_id)
  end

  private

  def all_players_should_be_authenticated
    self.players += players_credentials
      .map { |attributes| Student.authenticate(attributes) }
      .reject(&:blank?)

    self.players.uniq!

    if players_count && players_count != players.count
      errors[:players_credentials] << "Pogrešno korisničko ime ili lozinka."
    end
  end
end
