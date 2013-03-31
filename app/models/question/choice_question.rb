class ChoiceQuestion < Question
  store :data, accessors: [:provided_answers]
  data_value :provided_answers

  validate :validate_provided_answers

  def answer
    provided_answers.original.first
  end

  def randomize!
    provided_answers.shuffle!
    super
  end

  def category
    "choice"
  end

  private

  def validate_provided_answers
    if provided_answers.blank?
      errors.add(:provided_answers, :blank)
    elsif provided_answers.any?(&:blank?)
      errors.add(:provided_answers, :invalid)
    end
  end
end

class ChoiceQuestion
  class ProvidedAnswers < Array
    attr_reader :original

    def initialize(value)
      replace(convert_to_array(value))
      @original = dup
    end

    def shuffle!
      super until self.first != original.first
      self
    end

    private

    def convert_to_array(value)
      Array(value)
    end
  end
end
