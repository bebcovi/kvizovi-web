# encoding: utf-8

class SubmittedGame
  include ActiveAttr::Model

  attribute :quiz_id
  attribute :players_count, type: Integer
  attribute :players, default: []
  attr_accessor :players_credentials

  validate :quiz_id_must_be_present
  validate :all_players_should_be_authenticated

  def quiz
    @quiz ||= Quiz.find(quiz_id)
  end

  private

  def quiz_id_must_be_present
    if quiz_id.blank?
      errors[:base] << "Niste izabrali kviz."
    end
  end

  def all_players_should_be_authenticated
    self.players += players_credentials
      .map { |hash| Student.authenticate(hash) }
      .reject { |record| record == false }

    if players.count != players_count
      errors[:base] << "Drugi igrač nije uspješno autenticiran."
    end
  end
end
