require_relative "../question"
require_relative "data/boolean_question_data"

class BooleanQuestion < Question
  delegate :answer, to: :data

  def true?
    answer
  end

  def false?
    not true?
  end

  def correct_answer?(value)
    answer.to_s == value.to_s
  end

  def points
    1
  end
end
