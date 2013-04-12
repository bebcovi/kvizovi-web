class QuestionExhibit
  def self.exhibit(question)
    "#{question.class.name}Exhibit".constantize.new(question)
  end
end

class AssociationQuestionExhibit < SimpleDelegator
  def associations
    result = __getobj__.associations.dup
    until result != __getobj__.associations
      result = Hash[result.keys.shuffle.zip(result.values.shuffle)]
    end
    Associations.new(result)
  end

  class Associations
  end
end

class ChoiceQuestionExhibit < SimpleDelegator
end

class TextQuestionExhibit < SimpleDelegator
end

class ImageQuestionExhibit < SimpleDelegator
end

class BooleanQuestionExhibit < SimpleDelegator
end
