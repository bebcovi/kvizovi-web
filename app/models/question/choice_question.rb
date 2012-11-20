# encoding: utf-8
require_relative "../question"

class ChoiceQuestion < Question
  data_accessor :provided_answers

  validate :validate_provided_answers

  def provided_answers
    @provided_answers ||= ProvidedAnswers.new(super || [])
  end

  def provided_answers=(array)
    @provided_answers = nil
    super([array.first] + array[1..-1].reject(&:blank?))
  end

  def answer
    provided_answers.original.first
  end

  def correct_answer?(value)
    answer == value
  end

  def randomize!
    provided_answers.shuffle!
    super
  end

  private

  def validate_provided_answers
    if provided_answers.first.blank?
      errors[:provided_answers] << "Prvi ponuđeni odgovor ne smije biti prazan."
    end
  end
end

class ChoiceQuestion
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
end
