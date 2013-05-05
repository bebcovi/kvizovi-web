class PlayedQuizzesController < ApplicationController
  before_filter :authenticate!

  def index
    if params[:quiz_id]
      @quiz = Quiz.find(params[:quiz_id])
      @played_quizzes = @quiz.played_quizzes
    elsif params[:student_id]
      @student = Student.find(params[:student_id])
      @played_quizzes = @student.played_quizzes
    else
      @played_quizzes = PlayedQuiz.scoped
    end
    @played_quizzes = @played_quizzes.descending.includes(:quiz_snapshot)
  end

  def show
    @played_quiz = PlayedQuiz.find(params[:id])
    if params[:quiz_id]
      @quiz = Quiz.find(params[:quiz_id])
      @order = @quiz.played_quizzes.ascending.index { |played_quiz| played_quiz.id = @played_quiz.id } + 1
    elsif params[:student_id]
      @student = Student.find(params[:student_id])
      @order = @student.played_quizzes.ascending.index { |played_quiz| played_quiz.id = @played_quiz.id } + 1
    end
  end
end
