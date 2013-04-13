class GamePresenter
  def initialize(hash, player_class)
    @questions    = hash[:questions]
    @player_ids   = hash[:players].map { |h| h[:id] }
    @player_class = player_class
  end

  def results
    players.zip(scores, score_percentages, player_numbers, ranks)
  end

  def players
    @players ||= @player_class.where(id: @player_ids)
  end

  def scores
    result = Array.new(players.count, 0)
    @questions.each_with_index do |question, index|
      result[index % players.count] += 1 if question[:answer] == true
    end
    result
  end

  def score_percentages
    scores.map { |score| percentage(score, total_score) }
  end

  def player_numbers
    (1..players.count).to_a
  end

  def ranks
    score_percentages.map do |score_percentage|
      case score_percentage
      when 0...30  then "znalac-malac"
      when 30...70 then "ekspert"
      when 70..100 then "super-ekspert"
      end
    end
  end

  def total_score
    @questions.count / players.count
  end

  private

  def percentage(part, whole)
    ((part.to_f / whole.to_f) * 100).round
  end
end
