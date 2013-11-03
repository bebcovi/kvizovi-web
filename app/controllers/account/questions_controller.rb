class Account::QuestionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_quiz

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
      redirect_to account_quiz_questions_path(@quiz), success: flash_success
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
      redirect_to account_quiz_questions_path(@quiz), success: flash_success
    else
      render :edit
    end
  end

  def edit_order
    @questions = @quiz.questions
  end

  def update_order
    @quiz.update_attributes!(quiz_params)
    redirect_to account_quiz_questions_path(@quiz), success: flash_success
  end

  def destroy
    @question = @quiz.questions.find(params[:id])
    @question.destroy
    redirect_to account_quiz_questions_path(@quiz), success: flash_success
  end

  private

  def assign_quiz
    @quiz = current_user.quizzes.find(params[:quiz_id])
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
