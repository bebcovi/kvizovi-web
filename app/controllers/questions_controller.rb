# encoding: utf-8

class QuestionsController < ApplicationController
  before_filter :assign_quiz

  def index
    @questions = @quiz.questions
  end

  def new
    @question = @quiz.questions(params[:category]).new
  end

  def create
    @question = @quiz.questions(params[:category]).new(params[:question])

    if @question.save
      redirect_to quiz_questions_path(@quiz), notice: "Pitanje je uspješno stvoreno."
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
      redirect_to quiz_questions_path(@quiz), notice: "Pitanje je uspješno izmijenjeno."
    else
      render :edit
    end
  end

  def delete
    @question = @quiz.questions.find(params[:id])
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    @quiz.questions.destroy(params[:id]) if @quiz.questions.exists?(params[:id])
    redirect_to quiz_questions_path(@quiz), notice: "Pitanje je uspješno izbrisano."
  end

  private

  def assign_quiz
    @quiz = current_school.quizzes.find(params[:quiz_id])
  end
end
