require "active_support/inflector/transliterate"
require "delegate"

class QuestionAnswer
  def self.new(question)
    decorator_class = "#{question.category.camelize}QuestionAnswer".constantize
    decorator_class.new(question)
  end
end

class AssociationQuestionAnswer < SimpleDelegator
  def correct_answer?(value)
    case value
    when Array
      Hash[associations] == Hash[value]
    when Hash
      Hash[associations] == value
    end
  end
end

class ChoiceQuestionAnswer < SimpleDelegator
  def correct_answer?(value)
    provided_answers.first == value
  end
end

class BooleanQuestionAnswer < SimpleDelegator
  def correct_answer?(value)
    answer == value
  end
end

class TextQuestionAnswer < SimpleDelegator
  include ActiveSupport::Inflector

  def correct_answer?(value)
    if value
      normalize(answer).casecmp(normalize(value)) == 0
    else
      false
    end
  end

  private

  def normalize(value)
    transliterate(value.strip.chomp("."))
  end
end
