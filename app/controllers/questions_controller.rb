class QuestionsController < ApplicationController
  before_filter :assign_scope

  def index
    @questions = if nested?
                   @scope.questions
                 else
                   Question.not_owned_by(current_user)
                 end
    @questions = @questions.filter(params[:filter]) if params[:filter]
    @questions = @questions.page(params[:page]).per_page(20) unless @scope.is_a?(Quiz)
  end

  def new
    @question = @scope.questions(params[:category]).new
    @question.school = current_user
  end

  def create
    @question = @scope.questions(params[:category]).new(params[:question])
    @question.school = current_user

    if @question.save
      redirect_to polymorphic_path([@scope, Question]), notice: notice
    else
      render :new
    end
  end

  def edit
    @question = @scope.questions.find(params[:id])
  end

  def update
    @question = @scope.questions.find(params[:id])

    if @question.update_attributes(params[:question])
      redirect_to polymorphic_path([@scope, Question]), notice: notice
    else
      render :edit
    end
  end

  def copy
    current_user.questions << Question.find(params[:id]).dup
    redirect_to polymorphic_path([@scope, Question]), notice: notice
  end

  def delete
    @question = @scope.questions.find(params[:id])
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    @scope.questions.find(params[:id]).destroy
    redirect_to polymorphic_path([@scope, Question]), notice: notice
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
end
