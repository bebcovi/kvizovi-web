class BrowserGame
  def initialize(store)
    @store = store
  end

  module ActionMethods
    def create!(game)
      # Storing info
      @store[:quiz_id] = game.quiz_id
      @store[:questions] = Hash[Quiz.find(game.quiz_id).question_ids.shuffle.zip([])]
      @store[:player_ids] = game.players.map(&:id)

      # Initialization
      @store[:current_player] = 0
      @store[:current_question] = 0
    end

    def update!(answer)
      @store[:questions][current_question.id] = current_question.correct_answer?(answer)
    end

    def switch_player!
      @store[:current_player] = (@store[:current_player] + 1) % @store[:player_ids].count
    end

    def next_question!
      @store[:current_question] += 1
    end

    def create_record!
      info = @store[:questions].group_by
        .each_with_index { |(k, v), idx| @store[:player_ids][idx % @store[:player_ids].count] }
        .tap { |hash| hash.each_key { |key| hash[key] = Hash[hash[key]] } }

      game = Game.create!(quiz_id: @store[:quiz_id], info: info)
      game.id
    end
  end

  module HelperMethods
    def questions_left
      @store[:questions].count - (@store[:current_question] + 1)
    end

    def current_question
      Question.find(@store[:questions].keys[@store[:current_question]]).tap do |question|
        def question.provided_answers
          if choice?
            result = super.shuffle
            result.shuffle! while result == super
            result
          elsif association?
            result = super.values.shuffle
            result.shuffle! while result == super.values
            Hash[super.keys.zip(result)]
          else
            super
          end
        end
      end
    end

    def current_question_number
      @store[:current_question] + 1
    end

    def questions_count
      @store[:questions].count
    end

    def finished?
      questions_left == 0
    end

    def current_player
      Student.find(@store[:player_ids][@store[:current_player]])
    end

    def current_player_number
      @store[:current_player] + 1
    end

    def quiz
      Quiz.find(@store[:quiz_id])
    end
  end

  include ActionMethods
  include HelperMethods
end
