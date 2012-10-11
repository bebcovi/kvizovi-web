module GamesHelper
  def progress
    ProgressPresenter.new(@question_number, @questions_count)
  end
end
