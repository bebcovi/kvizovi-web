class RemoveGradesFromQuizzes < ActiveRecord::Migration
  def up
    remove_column :quizzes, :grades
  end

  def down
    add_column :quizzes, :grades, :string_array
  end
end
