require "active_support/inflector/methods"

class GameState
  def initialize(store, options = {})
    @store = store
  end

  module ActionMethods
    def initialize!(hash)
      clean!

      # Storage of info
      @store[:quiz_id] = hash[:quiz_id]
      hash[:question_ids].each_with_index { |id, i| @store[:"question_id_#{i + 1}"] = id }
      hash[:player_ids].each_with_index { |id, i| @store[:"player_id_#{i + 1}"] = id }

      @store[:questions_count] = hash[:question_ids].count
      @store[:players_count] = hash[:player_ids].count

      @store[:clock] = hash[:clock]

      # Initialization
      @store[:current_player] = 1
      @store[:current_question] = 1

      @store[:start] = hash[:clock].now

      self
    end

    def save_answer!(answer)
      @store[:"question_answer_#{@store[:current_question]}"] = answer
    end

    def next_question!
      unless @store[:"question_answer_#{@store[:current_question]}"].nil?
        next_player!
        @store[:current_question] = @store[:current_question].to_i + 1
      end
    end

    def next_player!
      @store[:current_player] = (@store[:current_player].to_i % @store[:players_count].to_i) + 1
    end

    def clean!
      conditions = [
        ->(key) { key.to_s =~ /question_id_\d+/ },
        ->(key) { key.to_s =~ /question_answer_\d+/ },
        ->(key) { key.to_s =~ /player_id_\d+/ },
      ]
      @store.each do |key, _|
        if conditions.any? { |condition| condition.call(key) }
          @store.delete(key)
        end
      end
    end
  end

  module HelperMethods
    # Questions

    def current_question_number
      Integer(@store[:current_question])
    end

    def question_id(i)
      Integer(@store[:"question_id_#{i}"])
    end
    def current_question_id
      question_id(current_question_number)
    end

    def question_answer(i)
      return nil if @store[:"question_answer_#{i}"].nil?
      String(@store[:"question_answer_#{i}"]) == "true"
    end
    def current_question_answer
      question_answer(current_question_number)
    end

    def questions_count
      Integer(@store[:questions_count])
    end

    # Players

    def current_player_number
      Integer(@store[:current_player])
    end

    def player_id(i)
      Integer(@store[:"player_id_#{i}"])
    end
    def current_player_id
      player_id(current_player_number)
    end

    def players_count
      Integer(@store[:players_count])
    end

    # Other

    def game_over?
      current_question_number >= questions_count
    end

    def game_in_progress?
      not clean?
    end

    def clean?
      !@store.has_key?(:question_id_1)
    end

    def quiz_id
      Integer(@store[:quiz_id])
    end

    def start
      clock.parse(@store[:start].to_s)
    end

    def info
      {
        player_ids:       (1..players_count).map { |i| player_id(i) },
        quiz_id:          quiz_id,
        question_ids:     (1..questions_count).map { |i| question_id(i) },
        question_answers: (1..questions_count).map { |i| question_answer(i) },
        duration:         (clock.now - start).to_i,
        interrupted:      (current_question_answer == nil)
      }
    end

    private

    def clock
      @store[:clock].to_s.constantize
    end
  end

  include ActionMethods
  include HelperMethods
end
