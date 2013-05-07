require "delegate"

class QuestionShuffling
  def self.new(question)
    decorator_class = "#{question.category.camelize}QuestionShuffling".constantize
    decorator_class.new(question)
  end
end

class AssociationQuestionShuffling < SimpleDelegator
  def associations
    result = __getobj__.associations.dup
    until result != __getobj__.associations
      left_side, right_side = result.map(&:first), result.map(&:last)
      result = (left_side.shuffle).zip(right_side.shuffle)
    end
    result
  end
end

class ChoiceQuestionShuffling < SimpleDelegator
  def provided_answers
    result = __getobj__.provided_answers.dup
    until result.first != __getobj__.provided_answers.first
      result = result.shuffle
    end
    result
  end
end

class BooleanQuestionShuffling < SimpleDelegator
end

class TextQuestionShuffling < SimpleDelegator
end

class ImageQuestionShuffling < TextQuestionShuffling
end
