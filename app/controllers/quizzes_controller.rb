class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all

    respond_to do |format|
      format.json { render json: @quizzes }
    end
  end

  def show
    @quiz = Quiz.find(params[:id])

    respond_to do |format|
      format.json { render json: @quiz }
    end
  end

  def create
    @quiz = Quiz.create(params[:quiz])

    if @quiz.valid?
      head :created, location: quiz_path(@quiz)
    else
      render json: @quiz.errors, status: :bad_request
    end
  end

  def update
    @quiz = Quiz.find(params[:id])

    if @quiz.update_attributes(params[:quiz])
      head :ok
    else
      render json: @quiz.errors, status: :bad_request
    end
  end

  def destroy
    Quiz.destroy(params[:id])
    head :ok
  end
end
