module QuizHelper
  def game_progress_percentage
    percentage(@question_number - 1, @questions_count)
  end

  def render_feedback
    if @correct_answer
      render "quiz/feedback/positive"
    else
      render "quiz/feedback/negative"
    end
  end
end
