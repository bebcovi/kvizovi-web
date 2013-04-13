class Game
  module Commands
    def initialize!(hash)
      @store[:quiz_id]          = hash[:quiz_id]
      @store[:question_ids]     = hash[:question_ids].join(",")
      @store[:question_answers] = hash[:question_ids].count.times.map{"nil"}.join(",")
      @store[:player_ids]       = hash[:player_ids].join(",")

      @store[:current_player]   = 0
      @store[:current_question] = 0

      @store[:begin] = Time.now.to_i

      self
    end

    def save_answer!(answer)
      answers = @store[:question_answers].split(",")
      answers[Integer(@store[:current_question])] = answer.to_s
      @store[:question_answers] = answers.join(",")
    end

    def next_question!
      next_player!
      @store[:current_question] = Integer(@store[:current_question]) + 1
    end

    def next_player!
      @store[:current_player] =
        (Integer(@store[:current_player]) + 1) %
        @store[:player_ids].split(",").count
    end

    def finalize!
      @store[:end] = Time.now.to_i
    end
  end
end
