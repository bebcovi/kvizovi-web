# encoding: utf-8
require_relative "../question"

class AssociationQuestion < Question
  data_accessor :associations

  validate :validate_associations

  def associations
    @associations ||= Associations.new(super || {})
  end

  def associations=(value)
    @associations = nil
    hash = convert_to_hash(value).reject.each_with_index { |(key, value), index| key.blank? and value.blank? and index != 0 }
    super(hash)
  end

  def answer
    associations.original
  end

  def correct_answer?(value)
    answer == convert_to_hash(value)
  end

  def randomize!
    associations.shuffle!
    super
  end

  private

  def convert_to_hash(value)
    value.flatten == value ? Hash[*value] : Hash[value]
  end

  def validate_associations
    if associations.all? { |key, value| key.blank? and value.blank? }
      errors[:base] << "Mora postojati barem jedna asocijacija."
    elsif associations.any? { |key, value| key.blank? or value.blank? }
      errors[:base] << "Svaka asocijacija mora imati obje strane popunjene."
    end
  end
end

class AssociationQuestion
  class Associations < Hash
    attr_accessor :original

    alias left_side keys
    alias right_side values

    def initialize(value)
      replace(value)
      @original = self.dup
    end

    def shuffle!
      replace(Hash[(keys.shuffle).zip(values.shuffle)]) until self != original
      self
    end

    def shuffle
      dup.shuffle!
    end

    def ==(hash)
      each_key do |key|
        return false if self[key] != hash[key]
      end
      true
    end
  end
end
