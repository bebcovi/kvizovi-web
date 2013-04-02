class QuestionsController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_quiz
  before_filter :authorize!, only: [:new, :create, :edit, :update, :delete, :destroy]

  def index
    @questions = @quiz.questions.search(params[:query])
  end

  def new
    @question = question_class.new
  end

  def create
    @question = question_class.new(params[:question])

    if @question.valid?
      @quiz.questions << @question
      redirect_to quiz_questions_path(@quiz), notice: flash_success
    else
      binding.pry
      render :new
    end
  end

  def show
    @question = @quiz.questions.find(params[:id])
  end

  def edit
    @question = @quiz.questions.find(params[:id])
  end

  def update
    @question = @quiz.questions.find(params[:id])
    @question.assign_attributes(params[:question])

    if @question.valid?
      @question.save
      redirect_to quiz_questions_path(@quiz), notice: flash_success
    else
      render :edit
    end
  end

  def delete
    @question = @quiz.questions.find(params[:id])
  end

  def destroy
    @quiz.questions.destroy(params[:id]) if @quiz.questions.exists?(params[:id])
    redirect_to quiz_questions_path(@quiz), notice: flash_success
  end

  def copy
    @question = Question.find(params[:id]).dup
    @question.school = current_user
    render :new
  end

  def download
    new_question = Question.find(params[:id]).dup
    @scope.questions << new_question
    flash[:highlight] = new_question.id
    redirect_to polymorphic_path([@scope, Question]), notice: flash_success
  end

  def include
    @scope.questions << current_user.questions.find(params[:id])
    redirect_to polymorphic_path([current_user, Question], include: params[:quiz_id]), notice: flash_success(name: @scope.name)
  end

  def remove
    @scope.questions.delete(current_user.questions.find(params[:id]))
    redirect_to polymorphic_path([@scope, Question]), notice: flash_success
  end

  private

  def assign_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def authorize!
    if not current_user.quizzes.exists?(@quiz)
      redirect_to root_path, alert: flash_error(:unauthorized)
    end
  end

  def question_class
    "#{params[:category]}_question".camelize.constantize
  end

  protected

  def sub_layout
    "questions"
  end
end
