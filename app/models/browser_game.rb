class BrowserGame
  def initialize(controller)
    @controller = controller
  end

  module ActionMethods
    def create!(game)
      # Storing info
      session[:game] = {
        quiz_id: game.quiz.id,
        questions: Hash[game.quiz.question_ids.shuffle.zip([])],
        player_ids: game.players.map(&:id)
      }

      # Initialization
      session[:game].update \
        current_player: 0,
        current_question: 0
    end

    def update!(answer)
      session[:game][:questions][current_question.id] = current_question.correct_answer?(answer)
    end

    def switch_player!
      session[:game][:current_player] = (session[:game][:current_player] + 1) % session[:game][:player_ids].count
    end

    def next_question!
      session[:game][:current_question] += 1
    end

    def create_record!
      players_and_questions = session[:game][:questions].group_by
        .each_with_index { |(k, v), idx| session[:game][:player_ids][idx % session[:game][:player_ids].count] }
        .tap { |hash| hash.each_key { |key| hash[key] = Hash[hash[key]] } }

      game = Game.create!(quiz_id: session[:game][:quiz_id], info: players_and_questions)
      session[:game_id] = game.id
    end

    def clear!
      session.delete(:game)
    end
  end

  module HelperMethods
    def questions_left
      session[:game][:questions].count - (session[:game][:current_question] + 1)
    end

    def current_question
      Question.find(session[:game][:questions].keys[session[:game][:current_question]]).tap do |question|
        # Shuffle answers
        if question.choice?
          question.data.shuffle!
        elsif question.association?
          keys, shuffled_values = question.data.keys, question.data.values.shuffle
          question.data = Hash[keys.zip(shuffled_values)]
        end
      end
    end

    def finished?
      questions_left == 0
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
