class QuestionsController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_quiz
  before_filter :authorize!, except: [:index, :download_location, :download]

  def index
    @questions = @quiz.questions
  end

  def new
    @question = question_class.new
  end

  def create
    @question = question_class.new
    @question.assign_attributes(question_params)

    if @question.valid?
      @quiz.questions << @question
      redirect_to quiz_questions_path(@quiz), success: flash_success
    else
      render :new
    end
  end

  def edit
    @question = @quiz.questions.find(params[:id])
  end

  def update
    @question = @quiz.questions.find(params[:id])
    @question.assign_attributes(question_params)

    if @question.valid?
      @question.save
      redirect_to quiz_questions_path(@quiz), success: flash_success
    else
      render :edit
    end
  end

  def edit_order
    @questions = @quiz.questions
  end

  def update_order
    @quiz.update_attributes!(quiz_params)
    redirect_to quiz_questions_path(@quiz), success: flash_success
  end

  def download_location
    @question = @quiz.questions.find(params[:id])
  end

  def download
    question = @quiz.questions.find(params[:id]).dup
    destination_quiz = current_user.quizzes.find(params[:location])
    destination_quiz.questions << question
    redirect_to quiz_questions_path(@quiz), success: flash_success(quiz_name: @quiz.name)
  end

  def destroy
    @question = @quiz.questions.find(params[:id])
    @question.destroy
    redirect_to quiz_questions_path(@quiz), success: flash_success
  end

  private

  def assign_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def authorize!
    if @quiz.school != current_user
      redirect_to :back, error: flash_error("unauthorized")
    end
  end

  def question_class
    "#{params[:category]}_question".camelize.constantize
  end

  def question_params
    params.require(:question).permit!
  end

  def quiz_params
    params.require(:quiz).permit!
  end
end
