class ModifyGradesOnQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :grades_array, :string_array
  end
end
