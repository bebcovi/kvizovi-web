module QuizHelper
  def quiz_progress_percentage
    percentage(@quiz_play.current_question[:number] - 1,
               @quiz_play.questions_count)
  end

  def render_feedback
    if @question.correct_answer?(@quiz_play.current_question[:answer])
      render "quiz/feedback/positive"
    else
      render "quiz/feedback/negative"
    end
  end
end
