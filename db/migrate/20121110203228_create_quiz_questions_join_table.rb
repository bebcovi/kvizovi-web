class CreateQuizQuestionsJoinTable < ActiveRecord::Migration
  def change
    create_table :questions_quizzes, id: false do |t|
      t.integer :quiz_id
      t.integer :question_id
    end
    add_column :questions, :school_id, :integer
  end
end
