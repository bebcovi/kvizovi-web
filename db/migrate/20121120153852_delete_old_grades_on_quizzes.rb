class DeleteOldGradesOnQuizzes < ActiveRecord::Migration
  def up
    remove_column :quizzes, :grades
    rename_column :quizzes, :grades_array, :grades
  end

  def down
    rename_column :quizzes, :grades, :grades_array
    add_column :quizzes, :grades, :hstore
  end
end
