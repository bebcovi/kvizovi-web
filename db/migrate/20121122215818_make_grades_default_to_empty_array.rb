class MakeGradesDefaultToEmptyArray < ActiveRecord::Migration
  def up
    add_column :quizzes, :new_grades, :string_array, default: "{}"
  end

  def down
    remove_column :quizzes, :new_grades
  end
end
