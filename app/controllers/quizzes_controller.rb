# encoding: utf-8

class QuizzesController < ApplicationController
  before_filter :authenticate!

  def index
    @quizzes = current_user.quizzes
  end

  def new
    @quiz = current_user.quizzes.new
  end

  def create
    @quiz = current_user.quizzes.new(params[:quiz])

    if @quiz.save
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def edit
    @quiz = current_user.quizzes.find(params[:id])
  end

  def update
    @quiz = current_user.quizzes.find(params[:id])

    if @quiz.update_attributes(params[:quiz])
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def toggle_activation
    quiz = current_user.quizzes.find(params[:id])
    quiz.toggle!(:activated)
    if quiz.activated?
      flash[:notice] = %(Kviz "#{quiz}" je aktiviran") + (quiz.grades.none? ? ", ali trenutno nije dostupan niti jednom razredu." : ".")
    else
      flash[:notice] = %(Kviz "#{quiz}" je deaktiviran.)
    end
    redirect_to quizzes_path
  end

  def delete
    @quiz = current_user.quizzes.find(params[:id])
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    current_user.quizzes.destroy(params[:id])
    redirect_to quizzes_path, notice: flash_message(:notice)
  end

  protected

  def sub_layout
    "quizzes"
  end
end
