require_relative "../question"

class TextQuestion < Question
  alias_attribute :answer, :data
  attr_accessible :answer

  validates_presence_of :answer

  def correct_answer?(value)
    answer.casecmp(value.chomp(".")) == 0
  end

  def points
    5
  end
end
