class MakePlayedQuizzesInterruptedByDefault < ActiveRecord::Migration
  def change
    change_column :played_quizzes, :interrupted, :boolean, default: true
  end
end
