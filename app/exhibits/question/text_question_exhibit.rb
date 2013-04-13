require "active_support/inflector/transliterate"

class TextQuestionExhibit < BaseExhibit
  include ActiveSupport::Inflector

  def has_answer?(value)
    normalize(__getobj__.answer).casecmp(normalize(value)) == 0
  end

  private

  def normalize(value)
    transliterate(value.strip.chomp("."))
  end
end
