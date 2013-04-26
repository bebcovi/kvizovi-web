class PlayedQuizExhibit < BaseExhibit
  def results
    students.zip(scores, score_percentages, student_numbers, ranks)
  end

  def scores
    result = Array.new(students.count, 0)
    questions.each_with_index do |question, index|
      result[index % students.count] += 1 if question[:answer] == true
    end
    result
  end

  def score_percentages
    scores.map { |score| percentage(score, total_score) }
  end

  def student_numbers
    (1..students.count).to_a
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
    questions.count / students.count
  end

  private

  def percentage(part, whole)
    ((part.to_f / whole.to_f) * 100).round
  end
end
