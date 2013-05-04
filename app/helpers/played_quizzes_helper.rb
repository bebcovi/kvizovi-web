module PlayedQuizzesHelper
  def PlayedQuestions(played_quiz, &block)
    played_quiz.questions.each_with_index do |question, idx|
      answer = played_quiz.question_answers[idx]
      question = QuestionAnswer.new(question)

      if question.correct_answer?(answer)
        css_class = "text-success"
      elsif answer.nil?
        css_class = "muted"
      else
        css_class = "text-error"
      end

      yield [question, answer, css_class, idx]
    end
  end

  def Answer(question, answer, &block)
    send("#{question.category.camelize}Answer", question, answer, &block)
  end

  def AssociationAnswer(question, answer, &block)
    unless answer.nil? or answer == Question::NO_ANSWER
      answer.each do |left, right|
        if question.correct_answer?(answer)
          css_class = "text-success"
        elsif not [left, right].in?(question.answer)
          css_class = "text-error"
        end
        yield [[left, right], css_class]
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
          css_class = "text-success"
        elsif answer == value
          css_class = "text-error"
        end
        yield [text, css_class]
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
          css_class = "text-success"
        elsif answer == provided_answer
          css_class = "text-error"
        end
        yield [provided_answer, css_class]
      end
    else
      QuestionShuffling.new(question).provided_answers.each do |provided_answer|
        yield [provided_answer, nil]
      end
    end
  end

  def TextAnswer(question, answer, &block)
    if question.correct_answer?(answer)
      css_class = "text-success"
    elsif answer.nil? or answer == Question::NO_ANSWER
      css_class = "muted"
      answer = "(Nije odgovoreno)"
    else
      css_class = "text-error"
      additional = "(#{question.answer})"
    end
    yield [answer, css_class, additional]
  end

  alias ImageAnswer TextAnswer
end
