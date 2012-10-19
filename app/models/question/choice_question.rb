require_relative "../question"
require_relative "data/choice_question_data"

class ChoiceQuestion < Question
  delegate :provided_answers, to: :data

  def answer
    provided_answers.original.first
  end

  def correct_answer?(value)
    answer == value
  end

  def points
    2
  end

  def randomize!
    data.randomize!
    super
  end
end
