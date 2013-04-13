require_relative "game/commands"
require_relative "game/reading"

class Game
  def initialize(store)
    @store = store
  end

  include Commands
  include Reading

  def over?
    question(questions_count - 1)[:answer] != nil
  end
  alias finished? over?

  def to_h
    {
      players:   players,
      quiz:      quiz,
      questions: questions,
      begin:     begin_time,
      end:       end_time,
    }
  end
end
