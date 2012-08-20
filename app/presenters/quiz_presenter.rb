class QuizPresenter < BasePresenter
  presents :quiz

  def name
    quiz.name
  end

  def grades
    ordinalize(quiz.grades).to_sentence
  end

  def visibility
    form_for quiz do |f|
      if quiz.activated?
        f.hidden_field(:activated, value: false) + f.button(icon("eye-open"))
      else
        f.hidden_field(:activated, value: true) + f.button(icon("eye-close"))
      end
    end.html_safe
  end
end
