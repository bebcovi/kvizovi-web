class QuizPresenter < BasePresenter
  presents :quiz

  def name
    quiz.name
  end

  def activated?
    quiz.activated? ? "Da" : "Ne"
  end

  def grades
    ordinalize(quiz.grades).to_sentence
  end
end
