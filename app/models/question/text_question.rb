class TextQuestion < Question
  store :data, accessors: [:answer]

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
