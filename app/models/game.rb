class Game < ActiveRecord::Base
  belongs_to :quiz

  serialize :info

  before_create do
    players.zip(scores).each do |player, score|
      player.increase_score!(score)
    end
  end

  def players
    player_ids = info.keys
    Student.find(player_ids)
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
