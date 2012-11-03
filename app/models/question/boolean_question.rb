require_relative "../question"

class BooleanQuestion < Question
  data_accessor :answer

  validates_inclusion_of :answer, in: [true, false]

  def answer
    super
  end

  def answer=(value)
    super(eval(value.to_s))
  end

  def true?
    answer
  end

  def false?
    not true?
  end

  def correct_answer?(value)
    answer.to_s == value.to_s
  end
end
