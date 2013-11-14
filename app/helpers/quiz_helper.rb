module QuizHelper
  def quiz_progress_percentage
    percentage(@quiz_play.current_question[:number] - 1,
               @quiz_play.questions_count)
  end
end
