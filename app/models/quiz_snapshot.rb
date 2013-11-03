class QuizSnapshot < ActiveRecord::Base
  has_one :played_quiz

  serialize :quiz_attributes
  serialize :questions_attributes

  def self.capture(quiz_specification)
    students_count = quiz_specification.students.count
    _quiz          = quiz_specification.quiz
    _questions     = _quiz.questions.to_a
    _questions.pop until _questions.count % students_count == 0

    create!(
      quiz_id:              _quiz.id,
      quiz_attributes:      _quiz.attributes,
      questions_attributes: _questions.map(&:attributes),
    )
  end

  def quiz
    @quiz ||= Quiz.new(quiz_attributes)
  end

  def questions
    @questions ||= (questions_attributes || []).map do |question_attributes|
      question_attributes["type"].constantize.new(question_attributes)
    end
  end
end
