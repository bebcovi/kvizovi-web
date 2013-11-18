class Game
  class State
    def initialize(store)
      @store = store
    end

    def start_game!(questions, players)
      @store[:questions_count]  = (questions.count / players.count) * players.count
      @store[:players_count]    = players.count

      @store[:current_question] = 0
      @store[:current_player]   = 0
    end

    def next_question!
      @store[:current_question] = current_question + 1 unless last_question?
    end

    def next_player!
      @store[:current_player] = (current_player + 1) % players_count
    end

    def current_question
      Integer(@store[:current_question])
    end

    def current_player
      Integer(@store[:current_player])
    end

    private

    def questions_count
      Integer(@store[:questions_count])
    end

    def players_count
      Integer(@store[:players_count])
    end

    def last_question?
      current_question == questions_count - 1
    end
  end
end
