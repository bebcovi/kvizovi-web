class ChoiceQuestion < Question
  data_accessor :provided_answers

  validate :validate_provided_answers

  alias raw_provided_answers provided_answers
  def provided_answers
    raw_provided_answers || []
  end

  def answer
    provided_answers.first
  end

  def category
    "choice"
  end

  private

  def validate_provided_answers
    if provided_answers.empty?
      errors.add(:provided_answers, :blank)
    elsif provided_answers.any?(&:blank?)
      errors.add(:provided_answers, :invalid)
    end
  end
end
