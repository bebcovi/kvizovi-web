class BooleanQuestion < Question
  store :data,
    accessors: [:answer]

  validate :validate_answer

  def answer=(value)
    super(
      case value
      when String     then {"true" => true, "false" => false}[value]
      when TrueClass  then value
      when FalseClass then value
      end
    )
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
