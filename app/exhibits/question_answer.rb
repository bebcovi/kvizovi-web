require "active_support/inflector/transliterate"

class QuestionAnswer
  def self.new(question)
    "#{question.class.name}Answer".constantize.new(question)
  end
end

class AssociationQuestionAnswer < BaseExhibit
  def correct_answer?(value)
    case value
    when Array
      __getobj__.associations == value.in_groups_of(2)
    when Hash
      __getobj__.associations == value.to_a
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
    __getobj__.answer ==
      case value
      when String
        {"true" => true, "false" => false}[value]
      else
        value
      end
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
