class QuestionsController < ApplicationController
  def index
    @questions = Question.all

    respond_to do |format|
      format.html
      format.json { render json: @questions }
    end
  end

  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @question }
    end
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(params[:question])

    if @question.valid?
      head :created, location: question_path(@question)
    else
      render json: @question.errors, status: :bad_request
    end
  end

  def update
    @question = Question.find(params[:id])

    if @question.update_attributes(params[:question])
      head :ok
    else
      render json: @question.errors, status: :bad_request
    end
  end

  def destroy
    Question.destroy(params[:id])
    head :ok
  end
end
