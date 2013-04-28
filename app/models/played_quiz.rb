class PlayedQuiz < ActiveRecord::Base
  belongs_to :quiz_snapshot, dependent: :destroy
  delegate :quiz, :questions, to: :quiz_snapshot
  def students; Student.find(student_ids); end

  serialize :question_answers, Array

  def student_ids
    read_attribute(:student_ids).strip.split(" ")
  end

  def student_ids=(values)
    write_attribute(:student_ids, " #{values.join(" ")} ")
  end
end
