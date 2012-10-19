class GamesController < ApplicationController
  before_filter :authenticate_student!

  before_filter only: :edit do
    redirect_to new_game_path if not game_state.game_in_progress?
  end

  def new
    @game_submission = GameSubmission.new
    @quizzes = current_student.available_quizzes
  end

  def create
    @game_submission = GameSubmission.new(params[:game_submission])
    @game_submission.players << current_student

    if @game_submission.valid?
      game_state.initialize!(@game_submission.info)
      redirect_to edit_game_path
    else
      @quizzes = current_student.available_quizzes
      render :new
    end
  end

  def edit
    game_state.next_question!

    @quiz = quiz
    @player = current_player
    @question = current_question.randomize!
    @question_number = game_state.current_question_number
    @player_number = game_state.current_player_number
    @questions_count = game_state.questions_count
  end

  def update
    game_state.save_answer!(current_question.correct_answer?(answer))
    redirect_to feedback_game_path
  end

  def feedback
    @correct_answer = game_state.current_question_answer
    @game_finished = game_state.game_over?
    render layout: false if request.headers["X-fancyBox"]
  end

  def show
    @game_review = GameReview.new(game_state.info)
    game_state.clean!

    @quiz = @game_review.quiz
    @questions_count = @game_review.questions_count
  end

  def delete
    render layout: false if request.headers["X-fancyBox"]
  end

  def destroy
    game_state.finish_game!
    redirect_to new_game_path
  end

  private

  def answer
    params[:game][:answer] rescue nil
  end

  def game_state
    GameState.new($redis, clean_method: "flushdb")
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
