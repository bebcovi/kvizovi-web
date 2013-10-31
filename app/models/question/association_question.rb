class AssociationQuestion < Question
  store :data,
    accessors: [:associations]

  validate :validate_associations

  def associations
    super || []
  end

  def associations=(value)
    super(
      case value
      when Array then value.in_groups_of(2)
      when Hash  then value.to_a
      end
    )
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
