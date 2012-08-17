class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.integer :grade
      t.references :school

      t.timestamps
    end
    add_index :quizzes, :school_id
  end
end
