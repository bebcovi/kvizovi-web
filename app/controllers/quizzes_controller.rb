class QuizzesController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_user

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
      redirect_to quizzes_path, notice: flash_success
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
      if params[:return_to]
        redirect_to params[:return_to]
      else
        redirect_to quizzes_path, notice: flash_success
      end
    else
      render :edit
    end
  end

  def delete
    @quiz = @user.quizzes.find(params[:id])
  end

  def destroy
    quiz = @user.quizzes.find(params[:id])
    quiz.destroy
    redirect_to quizzes_path, notice: flash_success
  end

  private

  def assign_user
    @user = current_user
  end
end
