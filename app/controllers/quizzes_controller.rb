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
      redirect_to quizzes_path, notice: "Kviz je uspješno stvoren."
    else
      render :new
    end
  end

  def edit
    @quiz = current_school.quizzes.find(params[:id])
  end

  def update
    @quiz = current_school.quizzes.find(params[:id])

    if @quiz.update_attributes(params[:quiz])
      flash[:notice] = "Kviz je uspješno izmijenjen." unless params[:quiz][:activated]
      redirect_to quizzes_path
    else
      if params.key?(:activated)
        redirect_to quizzes_path, alert: @quiz.errors[:base].first
      else
        render :edit
      end
    end
  end

  def delete
    @quiz = current_school.quizzes.find(params[:id])
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    current_school.quizzes.destroy(params[:id]).first
    redirect_to quizzes_path, notice: "Kviz je uspješno izbrisan."
  end
end
