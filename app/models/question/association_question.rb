class AssociationQuestion < Question
  store :data, accessors: [:associations]
  data_value :associations

  validate :validate_associations

  def answer
    associations.original
  end

  def randomize!
    associations.shuffle!
    super
  end

  def category
    "association"
  end

  private

  def validate_associations
    if associations.empty?
      errors.add(:associations, :blank)
    elsif associations.any? { |key, value| key.blank? or value.blank? }
      errors.add(:associations, :invalid)
    end
  end
end

class AssociationQuestion
  class Associations < Hash
    attr_accessor :original

    alias left_side keys
    alias right_side values

    def initialize(value)
      replace(convert_to_hash(value))
      @original = dup
    end

    def shuffle!
      replace(Hash[(keys.shuffle).zip(values.shuffle)]) until self != original
      self
    end

    def ==(value)
      super(convert_to_hash(value))
    end

    private

    def convert_to_hash(value)
      if value
        value.flatten == value ? Hash[*value] : Hash[value]
      else
        {}
      end
    end
  end
end
