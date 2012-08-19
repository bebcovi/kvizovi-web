# encoding: utf-8

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
      game.start!
    else
      @quizzes = current_student.school.quizzes
      render :new
    end
  end

  def play
    @quiz = game.quiz
    @player = game.current_player
    @question = game.current_question
  end

  def update
    game.update!(params[:game].try(:[], :answer))

    if game.questions_left > 0
      game.next_question!
    else
      game.create_record!
      game.finish!
    end
  end

  def show
    @game = Game.find(session[:game_id])
  end

  private

  def game
    BrowserGame.new(self)
  end
  helper_method :game
end
