class PlayedQuizCreator
  def initialize(quiz_play)
    @quiz_play = quiz_play
  end

  def create
    quiz_snapshot_id = @quiz_play.quiz_snapshot[:id]
    question_answers = @quiz_play.questions.map { |q| q[:answer] }
    begin_time       = @quiz_play.begin_time
    end_time         = @quiz_play.end_time

    played_quiz = PlayedQuiz.create!(
      quiz_snapshot_id: quiz_snapshot_id,
      question_answers: question_answers,
      begin_time:       begin_time,
      end_time:         end_time,
    )

    students = Student.find(@quiz_play.students.map { |q| q[:id] })
    played_quiz.students = students
  end
end
