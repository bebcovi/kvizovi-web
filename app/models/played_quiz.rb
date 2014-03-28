class PlayedQuiz < ActiveRecord::Base
  belongs_to :quiz_snapshot, dependent: :destroy
  has_many :playings, -> { order(position: :asc) }
  has_many :players, through: :playings

  serialize :question_answers, Array

  scope :descending,      ->         { order(created_at: :desc) }
  scope :ascending,       ->         { order(created_at: :asc)  }
  scope :not_interrupted, ->         { where(interrupted: false) }
  scope :relevant_to,     ->(school) { joins(:players).
                                       where(students: {id: school.student_ids}).
                                       uniq }

  delegate :quiz, :questions, to: :quiz_snapshot
  delegate :name, to: :quiz

  def self.position(played_quiz)
    all.index(played_quiz) + 1
  end
end
