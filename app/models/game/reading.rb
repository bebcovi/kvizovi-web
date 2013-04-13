class Game
  module Reading
    def questions_count
      question_ids.count
    end

    def current_question
      question(Integer(@store[:current_question]))
    end

    def questions
      questions_count.times.map { |i| question(i) }
    end

    def players_count
      player_ids.count
    end

    def players
      players_count.times.map { |i| player(i) }
    end

    def current_player
      player(Integer(@store[:current_player]))
    end

    def quiz
      {id: Integer(@store[:quiz_id])}
    end

    def begin_time
      Time.at(Integer(@store[:begin]))
    end

    def end_time
      Time.at(Integer(@store[:end]))
    end

    private

    def question_ids
      @store[:question_ids].split(",").map do |id|
        Integer(id)
      end
    end

    def question_answers
      @store[:question_answers].split(",").map do |answer|
        {"true" => true, "false" => false, "nil" => nil}[answer]
      end
    end

    def question(i)
      {number: i + 1, id: question_ids[i], answer: question_answers[i]}
    end

    def player_ids
      @store[:player_ids].split(",").map do |id|
        Integer(id)
      end
    end

    def player(i)
      {number: i + 1, id: player_ids[i]}
    end
  end
end
