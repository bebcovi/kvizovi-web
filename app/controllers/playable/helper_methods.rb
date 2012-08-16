module Playable
  module HelperMethods
    def quiz
      @quiz ||= Quiz.find(game[:quiz_id])
    end

    def questions_left
      game[:question_ids].count
    end

    def current_question
      @question ||= Question.find(game[:question_ids].first)
    end

    def current_player
      @player ||= Student.find(game[:players][game[:current_player]][:id])
    end

    def players
      @players ||= game[:players].map { |hash| Student.find(hash[:id]) }
    end

    def scores
      game[:players].map { |hash| hash[:score] }
    end

    def single_player?() game[:players].count == 1 end
    def multi_player?()  game[:players].count >= 2 end

    private

    def game=(value) session[:game] = value end
    def game()       session[:game]         end
  end
end
