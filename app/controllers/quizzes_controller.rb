class QuizzesController < ApplicationController
  before_action :authenticate_student!

  def index
    @quizzes = Quiz.not_private.activated.by_popularity
    @quizzes = @quizzes.search(params[:q]) if params[:q].present?
    @quizzes = @quizzes.where(school_id: params[:school]) if params[:school]
    @quizzes = @quizzes.paginate(page: params[:page], per_page: 12)
  end

  def show
    @quiz = Quiz.activated.find(params[:id]).decorate
  rescue ActiveRecord::RecordNotFound
    redirect_to quizzes_path,
      alert: if Quiz.exists?(params[:id])
               "Traženi kviz je trenutno neaktivan. Može biti da autor radi neke izmjene."
             else
               "Traženi kviz ne postoji ili je izbrisan."
             end
  end

  def start
    quiz = Quiz.activated.find(params[:id])
    players = [current_student]

    game.start!(quiz, players)
    redirect_to play_quiz_path(game.quiz)
  end

  def play
  end

  def save_answer
    game.save_answer!(answer)
  end

  def next_question
    game.next_question!
    redirect_to play_quiz_path(game.quiz)
  end

  def results
    @played_quiz = game.results
  end

  def finish
    game.finish!

    unless game.interrupted?
      redirect_to results_quiz_path(game.quiz)
    else
      redirect_to quizzes_path
    end
  end

  private

  def game
    @game ||= Game.new(cookies)
  end
  helper_method :game

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
