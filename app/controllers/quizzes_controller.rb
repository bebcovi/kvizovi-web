class QuizzesController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_school

  def index
    @quizzes = @school.quizzes
  end

  def new
    @quiz = @school.quizzes.new
  end

  def create
    @quiz = @school.quizzes.new(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_success
    else
      render :new
    end
  end

  def edit
    @quiz = @school.quizzes.find(params[:id])
  end

  def update
    @quiz = @school.quizzes.find(params[:id])
    @quiz.assign_attributes(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_success
    else
      render :edit
    end
  end

  def toggle_activation
    quiz = @school.quizzes.find(params[:id])
    quiz.toggle!(:activated)
    redirect_to quizzes_path
  end

  def delete
    @quiz = @school.quizzes.find(params[:id])
  end

  def destroy
    quiz = @school.quizzes.find(params[:id])
    quiz.destroy
    redirect_to quizzes_path, notice: flash_success
  end

  private

  def assign_school
    @school = current_user
  end

  protected

  def sub_layout
    "quizzes"
  end
end
