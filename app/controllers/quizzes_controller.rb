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
      flash[:notice] = if params[:quiz][:activated] == "true"
                         "Kviz \"#{@quiz.name}\" je aktiviran."
                       elsif params[:quiz][:activated] == "false"
                         "Kviz \"#{@quiz.name}\" je deaktiviran."
                       else
                         "Kviz je uspješno izmijenjen."
                       end
      redirect_to quizzes_path
    else
      render :edit
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
