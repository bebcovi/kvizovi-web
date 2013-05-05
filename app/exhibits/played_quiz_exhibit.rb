class PlayedQuizExhibit < BaseExhibit
  def results
    students.zip(scores, score_percentages, student_numbers, ranks)
  end

  def scores
    result = Array.new(students.count, 0)
    question_answers.each_with_index do |answer, idx|
      result[idx % students.count] += 1 if QuestionAnswer.new(questions[idx]).correct_answer?(answer)
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

  def played_questions
    questions.map.with_index do |question, idx|
      question = QuestionAnswer.new(question)
      answer = question_answers[idx]
      status = if question.correct_answer?(answer) then "correct"
               elsif answer == Question::NO_ANSWER then "unanswered"
               elsif answer == nil                 then "interrupted"
               else                                     "wrong"
               end
      [question, answer, status, idx]
    end
  end

  private

  def percentage(part, whole)
    ((part.to_f / whole.to_f) * 100).round
  end
end
