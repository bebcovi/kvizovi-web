class QuestionsController < ApplicationController
  before_filter :assign_scope
  before_filter :assign_quiz, if: -> { params[:include] }

  def index
    @questions = if nested?
                   unless @quiz
                     @scope.questions
                   else
                     @scope.questions.not_belonging_to(@quiz)
                   end
                 else
                   Question.not_owned_by(current_user).public.without_example
                 end

    @questions = @questions.filter(params[:filter]) if params[:filter]
    @questions = @questions.page(params[:page]).per_page(20) unless @scope.is_a?(Quiz)
  end

  def new
    @question = current_user.questions(params[:category]).new
  end

  def create
    @question = current_user.questions(params[:category]).new(params[:question])

    if @question.save
      @scope.questions << @question if @scope.is_a?(Quiz)
      redirect_to polymorphic_path([@scope, Question]), notice: flash_message(:notice)
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = current_user.questions.find(params[:id])
  end

  def update
    @question = current_user.questions.find(params[:id])

    if @question.update_attributes(params[:question])
      redirect_to polymorphic_path([@scope, Question]), notice: flash_message(:notice)
    else
      render :edit
    end
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
    redirect_to polymorphic_path([@scope, Question]), notice: flash_message(:notice)
  end

  def include
    @scope.questions << current_user.questions.find(params[:id])
    redirect_to polymorphic_path([current_user, Question], include: params[:quiz_id]), notice: flash_message(:notice, name: @scope.name)
  end

  def remove
    @scope.questions.delete(current_user.questions.find(params[:id]))
    redirect_to polymorphic_path([@scope, Question]), notice: flash_message(:notice)
  end

  def delete
    @question = current_user.questions.find(params[:id])
  end

  def destroy
    current_user.questions.find(params[:id]).destroy
    redirect_to polymorphic_path([@scope, Question]), notice: flash_message(:notice)
  end

  private

  def assign_scope
    @scope = if params.has_key?(:quiz_id)
                current_user.quizzes.find(params[:quiz_id])
              elsif params.has_key?(:school_id)
                current_user
              end
  end

  def assign_quiz
    @quiz = Quiz.find(params[:include])
  end

  def nested?
    params.has_key?(:quiz_id) or params.has_key?(:school_id)
  end

  protected

  def sub_layout
    "questions"
  end
end
