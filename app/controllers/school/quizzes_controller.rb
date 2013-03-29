class School::QuizzesController < School::BaseController
  before_filter :authenticate!
  before_filter :load_school

  def index
    @quizzes = @school.quizzes
  end

  def new
    @quiz = @school.quizzes.new
  end

  def create
    @quiz = @school.quizzes.new(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def edit
    @quiz = @school.quizzes.find(params[:id])
  end

  def update
    @quiz = @school.quizzes.find(params[:id])
    @quiz.assign_attributes(params[:quiz])

    if @quiz.valid?
      @quiz.save
      redirect_to quizzes_path, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def toggle_activation
    quiz = @school.quizzes.find(params[:id])
    quiz.toggle!(:activated)
    redirect_to quizzes_path
  end

  def delete
    @quiz = @school.quizzes.find(params[:id])
  end

  def destroy
    quiz = @school.quizzes.find(params[:id])
    quiz.destroy
    redirect_to quizzes_path, notice: flash_message(:notice)
  end

  private

  def load_school
    @school = current_user
  end

  protected

  def sub_layout
    "quizzes"
  end
end
