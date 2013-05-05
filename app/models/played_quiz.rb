require "squeel"

class PlayedQuiz < ActiveRecord::Base
  belongs_to :quiz_snapshot, dependent: :destroy
  has_and_belongs_to_many :students

  serialize :question_answers, Array

  scope :descending, -> { order{created_at.desc} }
  scope :ascending,  -> { order{created_at.asc} }

  delegate :quiz, :questions, to: :quiz_snapshot
  delegate :name, to: :quiz

  def interrupted?
    question_answers.any?(&:nil?)
  end

  def interrupted_on?(idx)
    question_answers.index(&:nil?) == idx
  end

  def single_player?; students.count == 1; end
  def multi_player?;  students.count > 1;  end
end
