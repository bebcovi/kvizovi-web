class ChangeGradesInQuizzesToHstore < ActiveRecord::Migration
  def up
    remove_column :quizzes, :grades
    add_column :quizzes, :grades, :hstore
  end

  def down
    remove_column :quizzes, :grades
    add_column :quizzes, :grades, :string
  end
end
