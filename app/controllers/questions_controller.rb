class QuestionsController < ApplicationController
  before_filter :assign_parent

  def index
    @questions = questions
  end

  def new
    @question = questions(params[:category]).new
    @question.school = current_user
  end

  def create
    @question = questions(params[:category]).new(params[:question])
    @question.school = current_user

    if @question.save
      redirect_to polymorphic_path([@parent, Question]), notice: notice
    else
      render :new
    end
  end

  def edit
    @question = questions.find(params[:id])
  end

  def update
    @question = questions.find(params[:id])

    if @question.update_attributes(params[:question])
      redirect_to polymorphic_path([@parent, Question]), notice: notice
    else
      render :edit
    end
  end

  def copy
    @question = questions.find(params[:id]).dup
    @question.school = current_user
    @question.save
    redirect_to polymorphic_path([@parent, Question]), notice: notice
  end

  def delete
    @question = questions.find(params[:id])
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    questions.find(params[:id]).destroy
    redirect_to polymorphic_path([@parent, Question]), notice: notice
  end

  private

  def assign_parent
    @parent = if params.has_key?(:quiz_id)
                current_user.quizzes.find(params[:quiz_id])
              elsif params.has_key?(:school_id)
                current_user
              end
  end

  def questions(category = nil)
    if @parent
      @parent.questions(category)
    else
      "#{category.to_s.camelize}Question".constantize.where("school_id <> #{current_user.id}")
    end
  end
end
