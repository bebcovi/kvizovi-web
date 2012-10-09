require_relative "../question"

class BooleanQuestion < Question
  alias_attribute :answer, :data
  attr_accessible :answer

  validates_presence_of :answer

  def true?
    answer.to_s == "true"
  end

  def false?
    not true?
  end

  def correct_answer?(value)
    answer.to_s == value.to_s
  end

  def points
    1
  end
end
