class BrowserGame
  def initialize(controller)
    @controller = controller
  end

  module ActionMethods
    def create!(game)
      session[:game] = {
        quiz_id: game.quiz.id,
        questions: Hash[game.quiz.question_ids.shuffle.zip([])],
        player_ids: game.players.map(&:id)
      }
    end

    def start!
      first_player!
      redirect_to play_game_path(1)
    end

    def update!(answer)
      session[:game][:questions][current_question.id] = current_question.correct_answer?(answer)
    end

    def next_question!
      switch_player!
      redirect_to play_game_path(params[:question].to_i + 1)
    end

    def create_record!
      players_and_questions = session[:game][:questions].group_by
        .each_with_index { |(k, v), idx| session[:game][:player_ids][idx % session[:game][:player_ids].count] }
        .tap { |hash| hash.each_key { |key| hash[key] = Hash[hash[key]] } }

      game = Game.create!(quiz_id: session[:game][:quiz_id], info: players_and_questions)
      session[:game_id] = game.id
    end

    def finish!
      session.delete(:game)
      redirect_to game_path
    end

    private

    def first_player!
      session[:game][:current_player] = 0
    end

    def switch_player!
      session[:game][:current_player] = (session[:game][:current_player] + 1) % session[:game][:player_ids].count
    end
  end

  module HelperMethods
    def questions_left
      session[:game][:questions].count - params[:question].to_i
    end

    def current_question
      Question.find(session[:game][:questions].keys[params[:question].to_i - 1])
    end

    def current_player
      Student.find(session[:game][:player_ids][session[:game][:current_player]])
    end

    def quiz
      Quiz.find(session[:game][:quiz_id])
    end
  end

  include ActionMethods
  include HelperMethods

  def method_missing(*args, &block)
    @controller.send(*args, &block)
  end
end
