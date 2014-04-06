class QuizSnapshot < ActiveRecord::Base
  has_one :played_quiz

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
      question_class.new(question_attributes).tap do |question|
        question.send(:write_attribute, :image, question_attributes["image"])
      end
    end
  end
end
