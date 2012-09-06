# encoding: utf-8

class QuestionsController < ApplicationController
  before_filter do
    @quiz = current_school.quizzes.find(params[:quiz_id])
  end

  def index
    @questions = @quiz.questions
  end

  def show
    @question = @quiz.questions.find(params[:id])
  end

  def new
    if params[:category]
      @question = @quiz.questions.new(category: params[:category])
    else
      render :category
    end
  end

  def create
    @question = @quiz.questions.new(params[:question])

    if @question.save
      redirect_to quiz_path(@quiz)
    else
      render :new
    end
  end

  def edit
    @question = @quiz.questions.find(params[:id])
  end

  def update
    @question = @quiz.questions.find(params[:id])

    if @question.update_attributes(params[:question])
      redirect_to quiz_path(@quiz)
    else
      render :edit
    end
  end

  def destroy
    @quiz.questions.destroy(params[:id])
    redirect_to quiz_path(@quiz), notice: "Pitanje je izbrisano."
  end
end
