require "active_support/inflector/transliterate"
require "set"

class QuestionAnswer
  def self.new(question)
    "#{question.category.camelize}QuestionAnswer".constantize.new(question)
  end
end

class AssociationQuestionAnswer < BaseExhibit
  def correct_answer?(value)
    case value
    when Array
      Set.new(__getobj__.associations) == Set.new(value)
    when Hash
      Set.new(__getobj__.associations) == Set.new(value.to_a)
    end
  end
end

class ChoiceQuestionAnswer < BaseExhibit
  def correct_answer?(value)
    __getobj__.provided_answers.first == value
  end
end

class BooleanQuestionAnswer < BaseExhibit
  def correct_answer?(value)
    __getobj__.answer == value
  end
end

class TextQuestionAnswer < BaseExhibit
  include ActiveSupport::Inflector

  def correct_answer?(value)
    if value
      normalize(__getobj__.answer).casecmp(normalize(value)) == 0
    else
      false
    end
  end

  private

  def normalize(value)
    transliterate(value.strip.chomp("."))
  end
end

class ImageQuestionAnswer < TextQuestionAnswer
end
