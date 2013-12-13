class AddTimeToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :time, :integer, default: 5
  end
end
