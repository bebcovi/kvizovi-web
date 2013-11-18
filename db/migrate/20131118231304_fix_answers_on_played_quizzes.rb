class FixAnswersOnPlayedQuizzes < ActiveRecord::Migration
  class QuizSnapshot < ActiveRecord::Base
    serialize :questions_attributes
  end

  class PlayedQuiz < ActiveRecord::Base
    belongs_to :quiz_snapshot
    serialize :question_answers, Array
  end

  def change
    add_column :played_quizzes, :interrupted, :boolean, default: false

    PlayedQuiz.find_each do |played_quiz|
      played_quiz.update(interrupted: true) if played_quiz.question_answers.any?(&:nil?)
      played_quiz.question_answers.pop while played_quiz.question_answers.last.nil? and not played_quiz.question_answers.empty?
      played_quiz.question_answers.map! do |answer|
        answer == "NO_ANSWER" ? nil : answer
      end
      played_quiz.save
    end
  end
end
