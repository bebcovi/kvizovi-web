class QuizController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_student, :assign_quiz_state

  def choose
    @quiz_specification = QuizSpecification.new
    @quizzes = @student.school.quizzes.activated
  end

  def prepare
    @quiz_specification = QuizSpecification.new(params[:quiz_specification])
    @quiz_specification.students << @student

    if @quiz_specification.valid?
      quiz_runner.prepare!(@quiz_specification.to_h)
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
    quiz_runner.save_answer!(question.correct_answer?(params[:answer]))
    redirect_to action: :answer_feedback
  end

  def answer_feedback
    @question = current_question
  end

  def next_question
    quiz_runner.next_question!
    redirect_to action: :play
  end

  def results
    @played_quiz = PlayedQuizExhibit.new(PlayedQuiz.find(params[:id]))
    @quiz        = @played_quiz.quiz
  end

  def interrupt
  end

  def finish
    quiz_runner.finish!
    played_quiz = PlayedQuiz.create_from_hash(quiz_state.to_h)

    if quiz_state.finished?
      redirect_to action: :results, id: played_quiz.id
    else
      redirect_to action: :choose
    end
  end

  private

  def assign_student
    @student = current_user
  end

  def assign_quiz_state
    @quiz_state = quiz_state
  end

  def quiz_state
    QuizState.new(cookies)
  end

  def quiz_runner
    QuizRunner.new(cookies)
  end

  def quiz
    Quiz.find(quiz_state.quiz[:id])
  end

  def current_question
    Question.find(quiz_state.current_question[:id])
  end

  def current_student
    Student.find(quiz_state.current_student[:id])
  end
end
