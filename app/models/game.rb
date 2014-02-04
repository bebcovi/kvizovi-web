require_relative "game/state"

class Game
  def initialize(store)
    @store = store
    @state = State.new(store)
  end

  def start!(quiz, players)
    prepare_quiz!(quiz, players)
    @state.start_game!(quiz.questions, players)
  end

  def save_answer!(answer)
    unless current_question_answered?
      played_quiz.question_answers << answer
      played_quiz.end_time = Time.now
      played_quiz.save
    end
  end

  def next_question!
    if current_question_answered?
      @state.next_question!
      @state.next_player!
    end
  end

  def finish!
    played_quiz.end_time = Time.now
    played_quiz.interrupted = true if interrupted?
    played_quiz.save
  end

  def interrupted?
    played_quiz.question_answers.count < questions.count
  end

  def over?
    current_question == questions.last and current_question_answered?
  end

  def correct_answer?
    QuestionAnswer.new(current_question).correct_answer?(current_question_answer)
  end

  def current_question_answered?
    played_quiz.question_answers.count == current_question_number
  end

  delegate :quiz, :questions, :players, to: :played_quiz

  def current_question
    questions[current_question_number - 1]
  end

  def current_question_number
    @state.current_question + 1
  end

  def current_question_answer
    played_quiz.question_answers[@state.current_question]
  end

  def current_player
    players[current_player_number - 1]
  end

  def current_player_number
    @state.current_player + 1
  end

  def results
    played_quiz.decorate
  end

  def played_quiz
    @played_quiz ||= PlayedQuiz.find(@store[:played_quiz_id])
  end

  private

  def prepare_quiz!(quiz, players)
    played_quiz = PlayedQuiz.create!(
      begin_time:    Time.now,
      end_time:      Time.now,
      quiz_snapshot: QuizSnapshot.capture(quiz),
      players:       players.shuffle,
    )

    @store[:played_quiz_id] = played_quiz.id
  end
end
