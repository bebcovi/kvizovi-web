class QuizController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_student

  def choose
    @game_details = GameDetails.new
    @quizzes = @student.school.quizzes.activated
  end

  def prepare
    @game_details = GameDetails.new(params[:game_details])
    @game_details.player_class = Student
    @game_details.players << @student

    if @game_details.valid?
      game.initialize!(@game_details.to_h)
      redirect_to action: :play
    else
      @quizzes = @student.school.quizzes.activated
      render :choose
    end
  end

  def play
    @player          = Student.find(game.current_player[:id])
    @quiz            = Quiz.find(game.quiz[:id])
    @question        = Question.find(game.current_question[:id])
    @question_number = game.current_question[:number]
    @player_number   = game.current_player[:number]
    @questions_count = game.questions_count

    @question = QuestionExhibit.new(@question)
  end

  def save_answer
    question = Question.find(game.current_question[:id])
    question = QuestionExhibit.new(question)
    game.save_answer!(question.has_answer?(params[:answer]))
    redirect_to action: :answer_feedback
  end

  def answer_feedback
    @correct_answer = game.current_question[:answer]
    @game_over = game.over?
    @question = Question.find(game.current_question[:id])
  end

  def next_question
    game.next_question!
    redirect_to action: :play
  end

  def results
    @game            = GamePresenter.new(game.to_h, Student)
    @quiz            = Quiz.find(game.quiz[:id])
    @questions_count = game.questions_count
  end

  def interrupt
  end

  def finish
    game.finalize!
    PlayedGame.create_from_hash(game.to_h)

    if game.finished?
      redirect_to action: :results
    else
      redirect_to action: :play
    end
  end

  private

  def assign_student
    @student = current_user
  end

  def game
    @game_state ||= Game.new(cookies)
  end
end
