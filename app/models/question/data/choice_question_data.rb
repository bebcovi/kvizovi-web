# encoding: utf-8
require "active_record"
require "active_support/core_ext/object/blank"

class ChoiceQuestionData < ActiveRecord::Base
  attr_accessible :provided_answers

  serialize :provided_answers, Array

  validate :validate_provided_answers

  def provided_answers
    @provided_answers ||= ProvidedAnswers.new(read_attribute(:provided_answers))
  end

  def provided_answers=(value)
    array = convert_to_array(value)
    array.reject!.each_with_index { |element, index| element.blank? and index != 0 }
    write_attribute(:provided_answers, array)
    @provided_answers = ProvidedAnswers.new(array)
  end

  class ProvidedAnswers < Array
    attr_reader :original

    def initialize(array)
      @original = array
      super
    end

    def shuffle!
      super until self.first != original.first
      self
    end

    def shuffle
      dup.shuffle!
    end
  end

  def randomize!
    provided_answers.shuffle!
  end

  private

  def convert_to_array(value)
    Array.new(value)
  end

  def validate_provided_answers
    if provided_answers.first.blank?
      errors[:base] << "Prvi ponuđeni odgovor ne smije biti prazan."
    end
  end
end
