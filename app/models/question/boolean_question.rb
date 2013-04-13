class BooleanQuestion < Question
  data_accessor :answer

  validate :validate_answer

  alias raw_answer= answer=
  def answer=(value)
    self.raw_answer =
      case value
      when String     then {"true" => true, "false" => false}[value]
      when TrueClass  then value
      when FalseClass then value
      end
  end

  def true?()  answer == true  end
  def false?() answer == false end

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
