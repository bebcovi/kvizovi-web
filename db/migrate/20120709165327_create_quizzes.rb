class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.string :password

      t.timestamps
    end
  end
end
