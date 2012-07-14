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
    question = Question.create(params[:question])
    head :created, location: question_path(question)
  end

  def update
    Question.find(params[:id]).update_attributes(params[:question])
    head :ok
  end

  def destroy
    Question.destroy(params[:id])
    head :ok
  end
end
