class GamesController < ApplicationController
  before_filter :authenticate!

  before_filter except: [:new, :create] do
    redirect_to new_game_path if not game_state.game_in_progress?
  end

  def new
    @game_submission = GameSubmission.new
    @quizzes = current_user.available_quizzes
  end

  def create
    @game_submission = GameSubmission.new(params[:game_submission].merge(player_class: current_user.class))
    @game_submission.players << current_user

    if request.referer.in?([new_game_url, edit_quiz_url(@game_submission.quiz)])
      cookies[:referer] = request.referer
    end

    if @game_submission.valid?
      game_state.initialize!(@game_submission.info)
      redirect_to edit_game_path
    else
      @quizzes = current_user.available_quizzes
      render :new
    end
  end

  before_filter only: :edit do
    game_state.next_question!
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
    game_state.save_answer!(current_question.correct_answer?(params[:game].try(:[], :answer)))
    redirect_to feedback_game_path
  end

  def feedback
    @correct_answer = game_state.current_question_answer
    @game_over = game_state.game_over?
    @question = current_question
  end

  def show
    @game_review = GameReview.new(game_state.info.merge(player_class: current_user.class))
    @quiz = @game_review.quiz
    @questions_count = @game_review.questions_count
  end

  def delete
  end

  def destroy
    Game.create_from_info(game_state.info) unless current_user.is_a?(School)

    unless params[:interrupted] == "true"
      redirect_to game_path
    else
      game_state.clean!
      redirect_to before_game_path
    end
  end

  private

  def game_state
    GameState.new(cookies)
  end

  def current_question
    Question.find(game_state.current_question_id)
  end

  def current_player
    current_user.class.find(game_state.current_player_id)
  end

  def quiz
    Quiz.find(game_state.quiz_id)
  end

  def before_game_path
    cookies[:referer] || root_path
  end
  helper_method :before_game_path
end
