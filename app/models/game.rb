class Game < ActiveRecord::Base
  belongs_to :quiz

  serialize :info

  def players
    player_ids = info.keys
    Student.find(player_ids)
  end

  def scores
    info.values.map do |questions|
      score = 0
      questions.each do |id, answered|
        score += quiz.questions.find(id).points if answered
      end
      score
    end
  end

  def questions_answered
    info.values.map do |questions|
      count = questions.inject(0) do |count, (_, answered)|
        count += 1 if answered
        count
      end
      [count, questions.count]
    end
  end

  def total_points
    questions.sum(:points)
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
