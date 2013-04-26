class RenamePlayedGameToPlayedQuiz < ActiveRecord::Migration
  def change
    rename_table :played_games, :played_quizzes
  end
end
