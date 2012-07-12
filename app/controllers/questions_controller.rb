class QuestionsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json {
        @questions = Question.all
        render json: @questions
      }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json {
        @questions = Question.find(params[:id])
        render json: @questions
      }
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
