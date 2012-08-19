class QuizPresenter < BasePresenter
  presents :quiz

  def name
    quiz.name
  end

  def grade
    ordinalize(quiz.grade)
  end

  def activated?
    quiz.activated? ? "Da" : "Ne"
  end
end
