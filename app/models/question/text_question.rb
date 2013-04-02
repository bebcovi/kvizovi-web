require "active_support/inflector/transliterate"

class TextQuestion < Question
  store :data, accessors: [:answer]
  data_value :answer

  validate :validate_answer

  def category
    "text"
  end

  private

  def validate_answer
    if answer.blank?
      errors.add(:answer, :blank)
    end
  end
end

class TextQuestion
  class Answer < SimpleDelegator
    include ActiveSupport::Inflector

    def ==(value)
      apply_transformations(__getobj__).casecmp(apply_transformations(value)) == 0
    end

    private

    def apply_transformations(string)
      transliterate(string.chomp(".").strip)
    end
  end
end
