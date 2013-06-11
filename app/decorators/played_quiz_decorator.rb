class PlayedQuizDecorator < Draper::Decorator
  delegate_all

  def results
    students.zip(scores, score_percentages, student_numbers, ranks)
  end

  def scores
    result = Array.new(students_count, 0)
    question_answers.each_with_index do |answer, idx|
      if has_answers?
        result[idx % students_count] += 1 if QuestionAnswer.new(questions[idx]).correct_answer?(answer)
      else
        result[idx % students_count] += 1 if answer
      end
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
    questions_count / students_count
  end

  def played_questions
    raise "This played quiz didn't store answers" unless has_answers?
    _students = Student.find(students_order)
    questions.map.with_index do |question, idx|
      question = QuestionAnswer.new(question)
      answer = question_answers[idx]
      status = if question.correct_answer?(answer) then "correct"
               elsif answer == Question::NO_ANSWER then "unanswered"
               elsif answer == nil                 then "interrupted"
               else                                     "wrong"
               end
      [question, answer, _students[idx % students_count], status, idx]
    end
  end

  private

  def percentage(part, whole)
    ((part.to_f / whole.to_f) * 100).round
  end

  def students_count
    @students_count ||= students.count
  end

  def questions_count
    @questions_count ||= has_answers? ? questions.count : question_answers.count
  end
end
