class GameReview
  def initialize(hash)
    @hash = hash
  end

  def results
    players.zip(scores, player_numbers, ranks)
  end

  def players
    @players ||= player_class.find(@hash[:player_ids]).each do |player|
      if player.is_a?(School)
        player.instance_eval do
          def male?;   true end
          def female?; false end
        end
      end
    end
  end

  def scores
    grouped_questions = @hash[:question_ids].zip(@hash[:question_answers]).
      group_by.each_with_index { |_, i| i % @hash[:player_ids].count }.values
    grouped_questions.map do |question_group|
      question_group.inject(0) do |score, (question_id, answered)|
        score += (answered ? 1 : 0)
      end
    end
  end

  def total_score
    @hash[:question_ids].count / @hash[:player_ids].count
  end

  def player_numbers
    (1..@hash[:player_ids].count).to_a
  end

  def ranks
    scores.map { |score | percentage(score, total_score) }.map do |score_percentage|
      case score_percentage
      when 0...30  then "znalac-malac"
      when 30...70 then "ekspert"
      when 70..100 then "super-ekspert"
      end
    end
  end

  def questions_count
    @hash[:question_ids].count
  end

  def quiz
    @quiz ||= Quiz.find(@hash[:quiz_id])
  end

  private

  def percentage(part, whole)
    ((part.to_f / whole) * 100).round
  end

  def player_class
    @hash[:player_class]
  end
end
