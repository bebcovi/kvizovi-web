class QuizzesController < ApplicationController
  before_filter :authenticate!
  before_filter :load_user

  def index
    @quizzes = @user.quizzes
  end

  def new
    @quiz = @user.quizzes.new
  end

  def create
    @quiz = @user.quizzes.new(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def edit
    @quiz = @user.quizzes.find(params[:id])
  end

  def update
    @quiz = @user.quizzes.find(params[:id])
    @quiz.assign_attributes(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def toggle_activation
    quiz = @user.quizzes.find(params[:id])
    quiz.toggle!(:activated)
    redirect_to quizzes_path
  end

  def delete
    @quiz = @user.quizzes.find(params[:id])
  end

  def destroy
    quiz = @user.quizzes.find(params[:id])
    quiz.destroy
    redirect_to quizzes_path, notice: flash_message(:notice)
  end

  private

  def load_user
    @user = current_user
  end

  protected

  def sub_layout
    "quizzes"
  end
end
