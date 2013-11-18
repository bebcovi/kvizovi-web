class QuizController < ApplicationController
  before_action :authenticate_student!

  def choose
    @game_specification = GameSpecification.new
    assign_quizzes
  end

  def start
    @game_specification = GameSpecification.new(game_specification_params)
    @game_specification.players << current_student

    if @game_specification.valid?
      game.start!(@game_specification.quiz, @game_specification.players)
      redirect_to action: :play
    else
      assign_quizzes
      render :choose
    end
  end

  def play
  end

  def save_answer
    game.save_answer!(answer)
  end

  def next_question
    game.next_question!
    redirect_to action: :play
  end

  def results
    @played_quiz = game.results
  end

  def finish
    game.finish!

    unless game.interrupted?
      redirect_to action: :results
    else
      redirect_to action: :choose
    end
  end

  private

  def assign_quizzes
    @quizzes = current_student.school.quizzes.activated
  end

  def game
    @game ||= Game.new(cookies)
  end
  helper_method :game

  def game_specification_params
    params.require(:game_specification).permit!
  end

  def answer
    case game.current_question
    when BooleanQuestion
      {"true" => true, "false" => false}[params[:answer]]
    when TextQuestion
      params[:answer].blank? ? nil : params[:answer]
    when AssociationQuestion
      params[:answer].in_groups_of(2)
    when ChoiceQuestion
      params[:answer]
    end
  end
end
