require "active_record"

class Game < ActiveRecord::Base
  belongs_to :quiz

  serialize :info

  def players
    player_ids = info.keys
    Student.find(player_ids)
  end

  def scores
    info.values.map do |questions|
      points = self.questions.inject({}) { |hash, question| hash.update(question.id => question.points) }
      questions.inject(0) do |score, (question_id, answered)|
        score += (answered ? points[question_id] : 0)
      end
    end
  end

  def correct_answer?(question)
    questions = info.values.inject(:merge)
    question_id = question.respond_to?(:id) ? question.id : question
    questions[question_id]
  end

  def questions
    quiz.questions
  end
end
