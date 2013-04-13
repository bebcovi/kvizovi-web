class AssociationQuestion < Question
  data_accessor :associations

  validate :validate_associations

  alias raw_associations associations
  def associations
    raw_associations || {}
  end

  alias raw_associations= associations=
  def associations=(value)
    self.raw_associations =
      case value
      when Array then Hash[*value]
      when Hash  then value
      end
  end

  def answer
    associations
  end

  def category
    "association"
  end

  private

  def validate_associations
    if associations.empty?
      errors.add(:associations, :blank)
    elsif associations.any? { |pair| pair.any?(&:blank?) }
      errors.add(:associations, :invalid)
    end
  end
end
