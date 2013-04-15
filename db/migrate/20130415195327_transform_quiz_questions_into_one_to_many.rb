class TransformQuizQuestionsIntoOneToMany < ActiveRecord::Migration
  def up
    drop_table :questions_quizzes
    remove_column :questions, :school_id if column_exists?(:questions, :school_id)
  end

  def down
    create_table :questions_quizzes, id: false do |t|
      t.integer :quiz_id
      t.integer :question_id
    end
  end
end
