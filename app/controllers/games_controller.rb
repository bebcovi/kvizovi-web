# encoding: utf-8

class GamesController < ApplicationController
  include Playable

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])

    if @game.valid?
      create_game! @game,
        urls: {
          start:  {action: "show"},
          play:   {action: "play"},
          finish: {action: "overview"}
        }
      start_game!
    else
      render :new
    end
  end

  def show
  end

  def play
  end

  def update
    update_score!(current_question)

    if questions_left > 0
      switch_player!
      next_question!
    else
      finish_game!
    end
  end

  def overview
  end
end
