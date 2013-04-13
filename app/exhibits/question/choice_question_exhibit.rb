class ChoiceQuestionExhibit < BaseExhibit
  def provided_answers
    result = __getobj__.provided_answers.dup
    until result.first != __getobj__.provided_answers.first
      result = result.shuffle
    end
    result
  end

  def has_answer?(value)
    __getobj__.provided_answers.first == value
  end
end
