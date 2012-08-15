# encoding: utf-8

class QuestionsController < ApplicationController
  def index
    @questions = current_school.quizzes.find(params[:quiz_id]).questions
  end

  def show
    @question = current_school.quizzes.find(params[:quiz_id]).questions.find(params[:id])
  end

  def new
    @question = current_school.quizzes.find(params[:quiz_id]).questions.new
  end

  def create
    @question = current_school.quizzes.find(params[:quiz_id]).questions.create(params[:question])

    if @question.valid?
      redirect_to quiz_path(@question.quiz)
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :new
    end
  end

  def edit
    @question = current_school.quizzes.find(params[:quiz_id]).questions.find(params[:id])
  end

  def update
    @question = current_school.quizzes.find(params[:quiz_id]).questions.find(params[:id])

    if @question.update_attributes(params[:question])
      redirect_to quiz_path(@question.quiz)
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :edit
    end
  end

  def destroy
    question = current_school.quizzes.find(params[:quiz_id]).questions.destroy(params[:id])
    redirect_to quiz_path(question.quiz), notice: "Pitanje je uspješno izbrisano."
  end
end
