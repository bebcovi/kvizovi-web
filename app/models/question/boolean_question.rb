class BooleanQuestion < Question
  store :data, accessors: [:answer]
  data_value :answer

  validate :validate_answer

  def true?;  answer == true;  end
  def false?; answer == false; end

  def category
    "boolean"
  end

  private

  def validate_answer
    if answer == nil
      errors.add(:answer, :blank)
    elsif not (answer == true or answer == false)
      errors.add(:answer, :inclusion)
    end
  end
end

class BooleanQuestion
  class Answer
    def initialize(value)
      @value = convert_to_boolean(value)
    end

    def ==(value)
      @value == convert_to_boolean(value)
    end

    def method_missing(name, *args, &block)
      @value.send(name, *args, &block)
    end

    private

    def convert_to_boolean(value)
      if value.is_a?(String)
        {"true" => true, "false" => false}[value]
      else
        value
      end
    end
  end
end
