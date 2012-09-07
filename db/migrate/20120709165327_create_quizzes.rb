class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.string :grades
      t.boolean :activated, default: false
      t.references :school

      t.timestamps
    end
  end
end
