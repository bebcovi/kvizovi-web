class QuizController < ApplicationController
  before_action :authenticate_student!

  def choose
    @quiz_specification = QuizSpecification.new
  end

  def start
    @quiz_specification = QuizSpecification.new(quiz_specification_params)
    @quiz_specification.students << current_student

    if @quiz_specification.valid?
      quiz_snapshot = QuizSnapshot.capture(@quiz_specification)
      quiz_play.start!(quiz_snapshot, @quiz_specification.students)
      redirect_to action: :play
    else
      render :choose
    end
  end

  def play
  end

  def save_answer
    quiz_play.save_answer!(params[:answer])
  end

  def next_question
    quiz_play.next_question!
    redirect_to action: :play
  end

  def results
    @played_quiz = PlayedQuiz.find(params[:id]).decorate
  end

  def finish
    quiz_play.finish!
    played_quiz = PlayedQuizCreator.new(quiz_play).create

    unless quiz_play.interrupted?
      redirect_to action: :results, id: played_quiz.id
    else
      redirect_to action: :choose
    end
  end

  private

  def quizzes
    @quizzes ||= current_student.school.quizzes.activated
  end
  helper_method :quizzes

  def quiz_play
    @quiz_play ||= QuizPlay.new(cookies)
  end
  helper_method :quiz_play

  def current_player
    Student.find(quiz_play.current_student[:id])
  end
  helper_method :current_player

  def quiz
    quiz_snapshot.quiz
  end
  helper_method :quiz

  def current_question
    question = quiz_snapshot.questions[quiz_play.current_question[:number] - 1]
    QuestionAnswer.new(question)
  end
  helper_method :current_question

  def quiz_snapshot
    @quiz_snapshot ||= QuizSnapshot.find(quiz_play.quiz_snapshot[:id])
  end

  def quiz_specification_params
    params.require(:quiz_specification).permit!
  end
end
