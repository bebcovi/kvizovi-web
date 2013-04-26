module QuizHelper
  def quiz_progress_percentage
    percentage(@quiz_state.current_question[:number] - 1,
               @quiz_state.questions_count)
  end

  def render_feedback
    if @quiz_state.current_question[:answer]
      render "quiz/feedback/positive"
    else
      render "quiz/feedback/negative"
    end
  end
end
