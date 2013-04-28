class PlayedQuizCreator
  def initialize(quiz_play)
    @quiz_play = quiz_play
  end

  def create
    quiz_snapshot_id = @quiz_play.quiz_snapshot[:id]
    question_answers = @quiz_play.questions.map { |q| q[:answer] }
    begin_time       = @quiz_play.begin_time
    end_time         = @quiz_play.end_time
    student_ids      = @quiz_play.students.map { |s| s[:id] }

    PlayedQuiz.create!(
      quiz_snapshot_id: quiz_snapshot_id,
      question_answers: question_answers,
      begin_time:       begin_time,
      end_time:         end_time,
      student_ids:      student_ids,
    )
  end
end
