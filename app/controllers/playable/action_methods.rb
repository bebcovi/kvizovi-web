module Playable
  module ActionMethods
    def create_game!(game_record, options = {})
      self.game = {
        quiz_id:         game_record.quiz.id,
        question_ids:    game_record.quiz.questions.pluck(:id).shuffle,
        players:         game_record.players.map { |player| {id: player.id} },
        urls:            options[:urls]
      }
    end

    def start_game!
      initialize_game!
      redirect_to game[:urls][:start]
    end

    def initialize_game!
      # Initialize score
      game[:players].each { |hash| hash[:score] = 0 }
      # Initialize player
      game[:current_player] = 0
    end

    def update_score!(question)
      if question.correct_answer?(params[:game][:answer])
        game[:players][game[:current_player]][:score] += question.points
      end
      game[:question_ids].shift
    end

    def switch_player!
      game[:current_player] = (game[:current_player] + 1) % game[:players].count
    end

    def next_question!
      redirect_to game[:urls][:play].merge(question: params[:question].to_i + 1)
    end

    def finish_game!
      redirect_to game[:urls][:finish]
    end
  end
end
