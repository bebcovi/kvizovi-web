class TransformImageQuestionsIntoTextQuestions < ActiveRecord::Migration
  def up
    execute "UPDATE questions SET type = 'TextQuestion' WHERE type = 'ImageQuestion'"
  end

  def down
  end
end
