class AddLettersToStudentGrades < ActiveRecord::Migration
  def up
    change_column :students, :grade, :string, limit: 2
  end

  def down
    change_column :students, :grade, :integer
  end
end
