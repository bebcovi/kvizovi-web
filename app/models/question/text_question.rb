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
  class Answer
    def initialize(value)
      @value = value
    end

    def ==(value)
      @value.chomp(".").strip.casecmp(value.chomp(".").strip) == 0
    end

    def blank?
      @value.blank?
    end
  end
end
