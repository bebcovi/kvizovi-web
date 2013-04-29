class PlayedQuiz < ActiveRecord::Base
  belongs_to :quiz_snapshot, dependent: :destroy
  has_and_belongs_to_many :students

  serialize :question_answers, Array

  delegate :quiz, :questions, to: :quiz_snapshot
end
