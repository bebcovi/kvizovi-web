require_relative "../question"

class TextQuestion < Question
  data_accessor :answer

  validates_presence_of :answer

  def correct_answer?(value)
    answer.casecmp(value.chomp(".")) == 0
  end
end
