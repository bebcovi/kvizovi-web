# encoding: utf-8

class GamesController < ApplicationController
  include Playable

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])

    if @game.valid?
      prepare_game!(@game)
      redirect_to game_path
    else
      render :new
    end
  end

  def show
  end

  def play
  end

  def update
    increase_score!
    toggle_player!

    unless last_question?
      redirect_to play_game_path(params[:question].to_i + 1)
    else
      redirect_to overview_game_path
    end
  end

  def overview
  end
end
