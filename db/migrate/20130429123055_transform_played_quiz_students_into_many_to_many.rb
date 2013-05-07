class TransformPlayedQuizStudentsIntoManyToMany < ActiveRecord::Migration
  def up
    remove_column :played_quizzes, :student_ids if column_exists?(:played_quizzes, :student_ids)
    create_table :played_quizzes_students, id: false do |t|
      t.integer :student_id
      t.integer :played_quiz_id
    end
  end

  def down
    add_column :played_quizzes, :student_ids, :string
    drop_table :played_quizzes_students
  end
end
