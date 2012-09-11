class GamesController < ApplicationController
  before_filter :authenticate_student!

  def new
    @game = SubmittedGame.new
    @quizzes = current_student.school.quizzes.activated
  end

  def create
    @game = SubmittedGame.new(params[:game])
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
    game.update!(params[:game].try(:[], :answer))

    if game.questions_left > 0
      game.next_question!
      redirect_to action: :edit
    else
      session[:game_id] = game.create_record!
      session.delete(:game)
      redirect_to action: :show
    end
  end

  def show
    @game = Game.find(session[:game_id])
    @questions_count = @game.questions.count
    @question_number = @questions_count
  end

  def destroy
    game.clear_store!
    redirect_to action: :new
  end

  private

  def game
    session[:game] ||= {}
    BrowserGame.new(session[:game])
  end
end
