class IndexQuizzesGrades < ActiveRecord::Migration
  def up
    execute "CREATE INDEX quizzes_grades ON quizzes USING GIN(grades)"
  end

  def down
    execute "DROP INDEX quizzes_grades"
  end
end
