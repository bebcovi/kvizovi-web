module PlayedQuizzesHelper
  def Answer(question, answer, &block)
    send("#{question.category.camelize}Answer", question, answer, &block)
  end

  def AssociationAnswer(question, answer, &block)
    if not answer.nil?
      answer.each(&block)
    else
      QuestionShuffling.new(question).associations.each(&block)
    end
  end

  def BooleanAnswer(question, answer, &block)
    [["Točno", true], ["Netočno", false]].each(&block)
  end

  def ChoiceAnswer(question, answer, &block)
    QuestionShuffling.new(question).provided_answers.each(&block)
  end

  def TextAnswer(question, answer, &block)
    yield answer
  end
end
