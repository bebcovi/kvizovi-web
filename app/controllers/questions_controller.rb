class QuestionsController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_quiz

  def index
    @questions = @quiz.questions.ascending.search(params[:query])
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

  def destroy
    Question.destroy(params[:id]) if Question.exists?(params[:id])
    redirect_to quiz_questions_path(@quiz), notice: flash_success
  end

  # def copy
  #   @question = Question.find(params[:id]).dup
  #   @question.school = current_user
  #   render :new
  # end

  # def download
  #   new_question = Question.find(params[:id]).dup
  #   @scope.questions << new_question
  #   flash[:highlight] = new_question.id
  #   redirect_to polymorphic_path([@scope, Question]), notice: flash_success
  # end

  # def include
  #   @scope.questions << current_user.questions.find(params[:id])
  #   redirect_to polymorphic_path([current_user, Question], include: params[:quiz_id]), notice: flash_success(name: @scope.name)
  # end

  private

  def assign_quiz
    @quiz = current_user.quizzes.find(params[:quiz_id])
  end

  def question_class
    "#{params[:category]}_question".camelize.constantize
  end

  def question_params
    params["#{params[:category]}_question"]
  end
end
