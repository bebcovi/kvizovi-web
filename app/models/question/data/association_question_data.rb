# encoding: utf-8
require "active_record"
require "active_support/core_ext/object/blank"

class AssociationQuestionData < ActiveRecord::Base
  attr_accessible :associations

  serialize :associations, Hash

  validate :validate_associations

  def associations
    @associations ||= Associations.new(read_attribute(:associations)).tap do |associations|
      associations.original = Associations.new(read_attribute(:associations))
    end
  end

  def associations=(value)
    hash = convert_to_hash(value)
    hash.reject!.each_with_index { |(key, value), index| key.blank? and value.blank? and index != 0 }
    write_attribute(:associations, hash)
    @associations = Associations.new(hash)
  end

  class Associations < Hash
    attr_accessor :original

    alias left_side keys
    alias right_side values

    def initialize(hash)
      replace(hash)
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

  def randomize!
    associations.shuffle!
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
