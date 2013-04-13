class QuizPresenter < BasePresenter
  presents :quiz

  def questions_count
    quiz.questions.count
  end

  def visibility_icon
    if quiz.activated?
      @t.link_to @t.icon("lamp-full"), @t.toggle_activation_quiz_path(quiz), class: "toggle-activation btn btn-success", title: "Deaktiviraj", method: :put
    else
      @t.link_to @t.icon("lamp"), @t.toggle_activation_quiz_path(quiz), class: "toggle-activation btn", title: "Aktiviraj", method: :put
    end
  end
end
