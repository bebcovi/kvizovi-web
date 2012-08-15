# encoding: utf-8

class Game
  include ActiveAttr::Model

  attribute :players_count, type: Integer
  attribute :players
  attribute :password

  attr_accessor :quiz

  validate :players_count_must_be_present
  validate :quiz_with_that_password_must_exist
  validate :all_players_must_authenticate

  private

  def players_count_must_be_present
    if players_count.blank?
      errors[:base] << "Broj igrača mora biti izabran."
    end
  end

  def quiz_with_that_password_must_exist
    self.quiz = Quiz.find_by_password!(password)
  rescue ActiveRecord::RecordNotFound
    errors[:base] << "Ne postoji kviz s tom lozinkom."
  end

  def all_players_must_authenticate
    self.players = players.map { |hash| Student.authenticate(hash) }.tap { |array| array.delete(false) }
    if self.players.count != players_count
      errors[:base] << "Jedan ili više igrača nije uspješno autenticirano."
    end
  end
end
