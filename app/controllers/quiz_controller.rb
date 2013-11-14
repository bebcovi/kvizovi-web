class QuizController < ApplicationController
  before_action :authenticate_user!
  before_action :assign_student
  before_action :redirect_if_question_was_already_answered, only: :play

  decorates_assigned :played_quiz

  def choose
    @quiz_specification = QuizSpecification.new
    @quizzes = @student.school.quizzes.activated
    @other_quizzes = Quiz.not_owned_by(@student.school).activated
  end

  def start
    @quiz_specification = QuizSpecification.new(quiz_specification_params)
    @quiz_specification.students << @student

    if @quiz_specification.valid?
      quiz_snapshot = QuizSnapshot.capture(@quiz_specification)
      quiz_play.start!(quiz_snapshot, @quiz_specification.students)
      redirect_to action: :play
    else
      @quizzes = @student.school.quizzes.activated
      render :choose
    end
  end

  def play
    @student  = current_player
    @quiz     = quiz
    @question = current_question
  end

  def save_answer
    quiz_play.save_answer!(params[:answer])
    @question = QuestionAnswer.new(current_question)
  end

  def next_question
    quiz_play.next_question!
    redirect_to action: :play
  end

  def results
    @played_quiz = PlayedQuiz.find(params[:id])
    @quiz        = @played_quiz.quiz
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

  def assign_student
    @student = current_user
  end

  def quiz_play
    @quiz_play ||= QuizPlay.new(cookies)
  end
  helper_method :quiz_play

  def current_player
    Student.find(quiz_play.current_student[:id])
  end

  def quiz
    quiz_snapshot.quiz
  end

  def current_question
    quiz_snapshot.questions[quiz_play.current_question[:number] - 1]
  end

  def quiz_snapshot
    @quiz_snapshot ||= QuizSnapshot.find(quiz_play.quiz_snapshot[:id])
  end

  def redirect_if_question_was_already_answered
    if quiz_play.current_question[:answer] != nil
      redirect_to action: :next_question
    end
  end

  def quiz_specification_params
    params.require(:quiz_specification).permit!
  end
end
