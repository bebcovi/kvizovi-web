class GamesController < ApplicationController
  before_filter :authenticate_student!

  def new
    @game_submission = GameSubmission.new
    @quizzes = current_student.available_quizzes
  end

  def create
    @game_submission = GameSubmission.new(params[:game_submission])
    @game_submission.players << current_student

    if @game_submission.valid?
      game_state.initialize!(@game_submission.info)
      redirect_to action: :edit
    else
      @quizzes = current_student.available_quizzes
      render :new
    end
  end

  def edit
    @quiz = quiz
    @player = current_player
    @question = current_question.randomize!
    @question_number = game_state.current_question_number
    @player_number = game_state.current_player_number
    @questions_count = game_state.questions_count
  end

  def update
    game_state.save_answer!(current_question.correct_answer?(params[:game][:answer]))

    unless game_state.game_finished?
      game_state.next_question!
      redirect_to action: :edit
    else
      redirect_to action: :show
    end
  end

  def show
    @game_review = GameReview.new(game_state.info)
    @quiz = @game_review.quiz
    @questions_count = @game_review.questions_count
  end

  def delete
  end

  def destroy
    redirect_to action: :new
    render layout: false if request.headers["X-fancyBox"]
  end

  private

  def game_state
    GameState.new(cookies)
  end

  def current_question
    Question.find(game_state.current_question_id)
  end

  def current_player
    Student.find(game_state.current_player_id)
  end

  def quiz
    Quiz.find(game_state.quiz_id)
  end
end
