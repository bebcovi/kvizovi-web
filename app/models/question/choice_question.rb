# encoding: utf-8
require_relative "../question"
require "active_support/core_ext/object/blank"

class ChoiceQuestion < Question
  attr_accessible :provided_answers

  serialize :data, Array

  validate :validate_provided_answers

  def answer
    provided_answers.first
  end

  def correct_answer?(value)
    answer == value
  end

  def provided_answers
    @provided_answers ||= ProvidedAnswers.new(data)
  end

  def provided_answers=(value)
    array = convert_to_array(value)
    array.reject!.each_with_index { |element, index| element.blank? and index != 0 }
    @provided_answers = ProvidedAnswers.new(self.data = array)
  end

  class ProvidedAnswers < Array
    def initialize(array)
      @original = array
      super
    end

    def shuffle!
      super until self.first != @original.first
      self
    end

    def shuffle
      dup.shuffle!
    end
  end

  def randomize!
    provided_answers.shuffle!
    self
  end

  def points
    2
  end

  private

  def convert_to_array(value)
    Array.new(value)
  end

  def validate_provided_answers
    if provided_answers.first.blank?
      errors[:provided_answers] << "Prvi ponuđeni odgovor (koji će ujedno biti i točan odgovor) ne smije biti prazan."
    end
  end
end
