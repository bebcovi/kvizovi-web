class AddPrivateToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :private, :boolean, default: false
  end
end
