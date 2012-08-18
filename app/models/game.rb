class Game < ActiveRecord::Base
  belongs_to :quiz

  serialize :info

  def players
    Student.find(info.keys)
  end

  def scores
    info.map do |_, questions|
      score = 0
      questions.each do |id, answered|
        score += quiz.questions.find(id).points if answered
      end
      score
    end
  end
end
