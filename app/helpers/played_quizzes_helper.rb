module PlayedQuizzesHelper
  def PlayedQuestions(played_quiz, &block)
    played_quiz.questions.each_with_index do |question, idx|
      answer = played_quiz.question_answers[idx]
      question = QuestionAnswer.new(question)

      if question.correct_answer?(answer)
        feedback = 1
      elsif answer.nil?
        feedback = -1
      else
        feedback = 0
      end

      yield [question, answer, feedback, idx]
    end
  end

  def Answer(question, answer, &block)
    send("#{question.category.camelize}Answer", question, answer, &block)
  end

  def AssociationAnswer(question, answer, &block)
    unless answer.nil? or answer == Question::NO_ANSWER
      answer.each do |left, right|
        if question.correct_answer?(answer)
          feedback = 1
        elsif not [left, right].in?(question.answer)
          feedback = 0
        end
        yield [[left, right], feedback]
      end
    else
      QuestionShuffling.new(question).associations.each do |left, right|
        yield [[left, right], nil]
      end
    end
  end

  def BooleanAnswer(question, answer, &block)
    unless answer.nil? or answer == Question::NO_ANSWER
      [["Točno", true], ["Netočno", false]].each do |text, value|
        if question.correct_answer?(value) and answer == value
          feedback = 1
        elsif answer == value
          feedback = 0
        end
        yield [text, feedback]
      end
    else
      ["Točno", "Netočno"].each do |text|
        yield [text, nil]
      end
    end
  end

  def ChoiceAnswer(question, answer, &block)
    unless answer.nil? or answer == Question::NO_ANSWER
      QuestionShuffling.new(question).provided_answers.each do |provided_answer|
        if question.correct_answer?(provided_answer) and answer == provided_answer
          feedback = 1
        elsif answer == provided_answer
          feedback = 0
        end
        yield [provided_answer, feedback]
      end
    else
      QuestionShuffling.new(question).provided_answers.each do |provided_answer|
        yield [provided_answer, nil]
      end
    end
  end

  def TextAnswer(question, answer, &block)
    if question.correct_answer?(answer)
      feedback = 1
    elsif answer.nil? or answer == Question::NO_ANSWER
      feedback = -1
      answer = ""
    else
      feedback = 0
    end
    yield [answer, feedback]
  end

  alias ImageAnswer TextAnswer
end
