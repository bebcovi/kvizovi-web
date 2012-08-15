module Playable
  def prepare_game!(game)
    store_game_info!(game)
    shuffle_questions!
    initialize_score!
    toggle_player!
  end

  def store_game_info!(game)
    self.game = {
      quiz_id:       game.quiz.id,
      players_count: game.players_count,
      players:       game.players.map { |player| {id: player.id} }
    }
  end

  def shuffle_questions!
    game[:question_ids] = quiz.questions.pluck(:id).shuffle
  end

  def initialize_score!
    game[:players].each { |hash| hash[:score] = 0 }
  end

  def quiz
    @quiz ||= Quiz.find(game[:quiz_id]) rescue nil
  end
  # helper_method :quiz

  def last_question?
    params[:question].to_i + 1 > game[:question_ids].count
  end

  def current_question
    @question ||= Question.find(game[:question_ids][params[:question].to_i - 1])
  end
  # helper_method :current_question

  def current_player
    @player ||= Student.find(game[:players][game[:current_player]][:id])
  end
  # helper_method :current_player

  def toggle_player!
    if game[:current_player]
      game[:current_player] = (game[:current_player].to_i + 1) % game[:players_count]
    else
      game[:current_player] = 0
    end
  end

  def increase_score!
    if current_question.correct_answer?(params[:game][:answer])
      game[:players][game[:current_player]][:score] += current_question.points
    end
  end

  def players
    @players ||= game[:players].map do |hash|
      Student.find(hash[:id]).tap { |student| student.score = hash[:score] }
    end
  end
  # helper_method :players

  def single_player?() game[:players_count] == 1 end
  def multi_player?()  game[:players_count] >= 2 end
  # helper_method :single_player?, :multi_player?

  def self.included(klass)
    klass.helper_method :quiz, :players, :game, :single_player?, :multi_player?,
      :current_question, :current_player
  end

  private

  def game
    session[:game]
  end
  # helper_method :game

  def game=(value)
    session[:game] = value
  end
end
