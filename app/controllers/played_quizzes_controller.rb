class PlayedQuizzesController < ApplicationController
  before_filter :authenticate!
  before_filter :assing_scope

  decorates_assigned :played_quiz

  def index
    @played_quizzes = @scope.played_quizzes.
      descending.
      includes(:quiz_snapshot, :students).
      paginate(page: params[:page], per_page: 15)
  end

  def show
    if PlayedQuiz.exists?(params[:id])
      @played_quiz = PlayedQuiz.find(params[:id])
      @order = @scope.played_quizzes.ascending.index { |played_quiz| played_quiz.id = @played_quiz.id } + 1
    else
      redirect_to played_quizzes_path(params.slice(:quiz_id, :student_id)), alert: flash_error
    end
  end

  private

  def assing_scope
    @scope = case
             when params[:student_id] then Student.find(params[:student_id])
             when params[:quiz_id]    then Quiz.find(params[:quiz_id])
             else                          current_user
             end
  end
end
