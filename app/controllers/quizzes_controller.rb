class QuizzesController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_user
  before_filter :authorize!, only: [:edit, :update, :delete, :destroy]

  def index
    @quizzes = params[:scope].blank? ? @user.quizzes : Quiz.not_owned_by(@user).order_by_school
    @quizzes = @quizzes.includes(:school).descending.paginate(per_page: 15, page: params[:page])
  end

  def new
    @quiz = @user.quizzes.new
  end

  def create
    @quiz = @user.quizzes.new(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_success
    else
      render :new
    end
  end

  def edit
    @quiz = @user.quizzes.find(params[:id])
  end

  def update
    @quiz = @user.quizzes.find(params[:id])
    @quiz.assign_attributes(params[:quiz])

    if @quiz.valid?
      @quiz.save
      if params[:return_to]
        redirect_to params[:return_to]
      else
        redirect_to quizzes_path, notice: flash_success
      end
    else
      render :edit
    end
  end

  def delete
    @quiz = @user.quizzes.find(params[:id])
  end

  def destroy
    quiz = @user.quizzes.find(params[:id])
    quiz.destroy
    redirect_to quizzes_path, notice: flash_success
  end

  private

  def assign_user
    @user = current_user
  end

  def authorize!
    if not @user.quizzes.exists?(params[:id])
      redirect_to :back, alert: flash_error("unauthorized")
    end
  end
end
