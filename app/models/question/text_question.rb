require_relative "../question"
require_relative "data/text_question_data"

class TextQuestion < Question
  delegate :answer, to: :data

  def correct_answer?(value)
    answer.casecmp(value.chomp(".")) == 0
  end

  def points
    5
  end
end
