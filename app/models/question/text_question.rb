require_relative "../question"

class TextQuestion < Question
  data_accessor :answer

  validates_presence_of :answer

  def correct_answer?(value)
    answer.chomp(".").strip.casecmp(value.chomp(".").strip) == 0
  end
end
