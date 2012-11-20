class QuestionsController < ApplicationController
  before_filter :assign_scope

  def index
    @quiz = Quiz.find(params[:include]) if params[:include]
    @questions = if nested?
                   unless params[:include]
                     @scope.questions
                   else
                     @scope.questions.not_belonging_to(@quiz)
                   end
                 else
                   Question.not_owned_by(current_user)
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

  def include
    @scope.questions << Question.find(params[:id])
    redirect_to :back
  end

  def delete
    @question = current_user.questions.find(params[:id])
  end

  def remove
    @scope.questions.delete(current_user.questions.find(params[:id]))
    redirect_to :back, notice: flash_message(:notice)
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

  def nested?
    params.has_key?(:quiz_id) or params.has_key?(:school_id)
  end

  protected

  def sub_layout
    "questions"
  end
end
