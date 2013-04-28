class QuizController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_student, :assign_quiz_play

  def choose
    @quiz_specification = QuizSpecification.new
    @quizzes = @student.school.quizzes.activated
  end

  def start
    @quiz_specification = QuizSpecification.new(params[:quiz_specification])
    @quiz_specification.students << @student

    if @quiz_specification.valid?
      quiz_snapshot = QuizSnapshot.capture(@quiz_specification)
      @quiz_play.start!(quiz_snapshot, @quiz_specification.students)
      redirect_to action: :play
    else
      @quizzes = @student.school.quizzes.activated
      render :choose
    end
  end

  def play
    @student  = current_student
    @quiz     = quiz
    @question = QuestionShuffling.new(current_question)
  end

  def save_answer
    question = QuestionAnswer.new(current_question)
    @quiz_play.save_answer!(question.correct_answer?(params[:answer]))
    redirect_to action: :answer_feedback
  end

  def answer_feedback
    @question = current_question
  end

  def next_question
    @quiz_play.next_question!
    redirect_to action: :play
  end

  def results
    @played_quiz = PlayedQuizExhibit.new(PlayedQuiz.find(params[:id]))
    @quiz        = @played_quiz.quiz
  end

  def interrupt
  end

  def finish
    @quiz_play.finish!
    played_quiz = PlayedQuizCreator.new(@quiz_play).create

    unless @quiz_play.interrupted?
      redirect_to action: :results, id: played_quiz.id
    else
      redirect_to action: :choose
    end
  end

  private

  def assign_student
    @student = current_user
  end

  def assign_quiz_play
    @quiz_play = QuizPlay.new(cookies)
  end

  def current_student
    Student.find(@quiz_play.current_student[:id])
  end

  def quiz
    quiz_snapshot.quiz
  end

  def current_question
    quiz_snapshot.questions[@quiz_play.current_question[:number] - 1]
  end

  def quiz_snapshot
    @quiz_snapshot ||= QuizSnapshot.find(@quiz_play.quiz_snapshot[:id])
  end
end
