class RemoveOldGrades < ActiveRecord::Migration
  def up
    remove_column :quizzes, :grades
    rename_column :quizzes, :new_grades, :grades
  end

  def down
    rename_column :quizzes, :grades, :new_grades
    add_column :quizzes, :grades, :string_array
  end
end
