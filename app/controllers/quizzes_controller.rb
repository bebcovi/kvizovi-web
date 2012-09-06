# encoding: utf-8

class QuizzesController < ApplicationController
  def index
    @quizzes = current_school.quizzes
  end

  def new
    @quiz = current_school.quizzes.new
  end

  def create
    @quiz = current_school.quizzes.new(params[:quiz])

    if @quiz.save
      redirect_to quiz_questions_path(@quiz)
    else
      render :new
    end
  end

  def show
    @quiz = current_school.quizzes.find(params[:id])
    redirect_to quiz_questions_path(@quiz)
  end

  def edit
    @quiz = current_school.quizzes.find(params[:id])
  end

  def update
    @quiz = current_school.quizzes.find(params[:id])

    if @quiz.update_attributes(params[:quiz])
      redirect_to quizzes_path, notice: "Podaci su izmijenjeni."
    else
      render :edit
    end
  end

  def destroy
    current_school.quizzes.destroy(params[:id]).first
    redirect_to quizzes_path, notice: "Kviz je izbrisan."
  end
end
