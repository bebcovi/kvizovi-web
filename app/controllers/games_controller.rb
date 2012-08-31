class GamesController < ApplicationController
  before_filter :authenticate_student!

  def new
    @game = SubmittedGame.new
    @quizzes = current_student.school.quizzes.activated
  end

  def create
    @game = SubmittedGame.new(params[:submitted_game])
    @game.players << current_student

    if @game.valid?
      game.create!(@game)
      redirect_to action: :edit
    else
      @quizzes = current_student.school.quizzes.activated
      render :new
    end
  end

  def edit
    @quiz = game.quiz
    @player = game.current_player
    @question = game.current_question
    @question_number = game.current_question_number
    @player_number = game.current_player_number
    @questions_count = game.questions_count
  end

  def update
    game.update!(params[:game][:answer])

    if game.questions_left > 0
      game.switch_player!
      game.next_question!
      redirect_to action: :edit
    else
      game.create_record!
      game.clear!
      redirect_to action: :show
    end
  end

  def show
    @game = Game.find(session[:game_id])
  end

  def destroy
    game.clear!
    redirect_to action: :new
  end

  private

  def game
    BrowserGame.new(self)
  end
end
