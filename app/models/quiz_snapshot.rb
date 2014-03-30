class QuizSnapshot < ActiveRecord::Base
  has_one :played_quiz
  belongs_to :quiz, counter_cache: :play_count

  serialize :quiz_attributes
  serialize :questions_attributes

  def self.capture(quiz)
    create!(
      quiz_id:              quiz.id,
      quiz_attributes:      quiz.attributes,
      questions_attributes: quiz.questions.map(&:attributes),
    )
  end

  def quiz
    @quiz ||= Quiz.new(quiz_attributes)
  end

  def questions
    @questions ||= Array(questions_attributes).map do |question_attributes|
      question_class = question_attributes["type"].constantize
      question_class.new(question_attributes)
    end
  end
end
