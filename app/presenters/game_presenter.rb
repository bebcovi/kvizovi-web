class GamePresenter < BasePresenter
  presents :game

  def results
    game.players.zip(game.scores, 1..game.players.count)
  end

  def total_score
    game.questions.count / game.players.count
  end
end
