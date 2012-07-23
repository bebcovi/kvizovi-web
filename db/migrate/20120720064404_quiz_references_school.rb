class QuizReferencesSchool < ActiveRecord::Migration
  def change
    add_column :quizzes, :school_id, :integer
    add_index :quizzes, :school_id
  end
end
