class AddShuffleQuestionsToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :shuffle_questions, :boolean, default: false
  end
end
