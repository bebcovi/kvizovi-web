class QuestionsController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_quiz
  before_filter :authorize_user!, except: [:index, :download_location, :download]

  def index
    @questions = @quiz.questions.ascending
  end

  def new
    @question = question_class.new
  end

  def create
    @question = question_class.new
    @question.assign_attributes(question_params)

    if @question.valid?
      @quiz.questions << @question
      redirect_to quiz_questions_path(@quiz), notice: flash_success
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
      redirect_to quiz_questions_path(@quiz), notice: flash_success
    else
      render :edit
    end
  end

  def edit_order
    @questions = @quiz.questions
  end

  def update_order
    @quiz.update_attributes!(params[:quiz])
    redirect_to quiz_questions_path(@quiz), notice: flash_success
  end

  def download_location
    @question = @quiz.questions.find(params[:id])
  end

  def download
    question = @quiz.questions.find(params[:id]).dup
    destination_quiz = current_user.quizzes.find(params[:location])
    destination_quiz.questions << question
    redirect_to quiz_questions_path(@quiz), notice: flash_success(quiz_name: @quiz.name)
  end

  def destroy
    @question = @quiz.questions.find(params[:id])
    @question.destroy
    redirect_to quiz_questions_path(@quiz), notice: "#{flash_success} #{undo_link}"
  end

  private

  def undo_link
    view_context.link_to "Vrati", revert_version_path(@question.versions.scoped.last), method: :post
  end

  def assign_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def authorize_user!
    if @quiz.school != current_user
      redirect_to :back, alert: flash_error("unauthorized")
    end
  end

  def question_class
    "#{params[:category]}_question".camelize.constantize
  end

  def question_params
    params["#{params[:category]}_question"]
  end
end
