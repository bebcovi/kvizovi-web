module GamesHelper
  def game_progress_percentage
    percentage(@question_number - 1, @questions_count)
  end

  def render_feedback
    if @correct_answer
      render "games/feedback/positive"
    else
      render "games/feedback/negative"
    end
  end
end
