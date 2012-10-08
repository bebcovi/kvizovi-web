require_relative "../question"
require "active_support/core_ext/object/blank"

class AssociationQuestion < Question
  attr_accessible :associations

  serialize :data, Hash

  validate :validate_associations

  def answer
    associations
  end

  def correct_answer?(value)
    answer == convert_to_hash(value)
  end

  def associations
    @associations ||= Associations.new(data)
  end

  def associations=(value)
    hash = convert_to_hash(value)
    hash.reject!.each_with_index { |(key, value), index| key.blank? and value.blank? and index != 0 }
    @associations = Associations.new(self.data = hash)
  end

  class Associations < Hash
    alias left_side keys
    alias right_side values

    def initialize(hash)
      @original = hash
      replace(hash)
    end

    def shuffle!
      replace(Hash[keys.zip(values.shuffle)]) until self.values != @original.values
      self
    end

    def shuffle
      dup.shuffle!
    end
  end

  def randomize!
    associations.shuffle!
    self
  end

  def points
    4
  end

  private

  def convert_to_hash(value)
    value.flatten == value ? Hash[*value] : Hash[value]
  end

  def validate_associations
    if associations.all? { |key, value| key.blank? and value.blank? }
      errors[:associations] << "Mora postojati barem jedna asocijacija."
    elsif associations.any? { |key, value| key.blank? or value.blank? }
      errors[:associations] << "Svaka asocijacija mora imati obje strane popunjene."
    end
  end
end
