class RemoveCompletedSurveyFromSchoolsAndStudents < ActiveRecord::Migration
  def up
    remove_column :students, :completed_survey
    remove_column :schools, :completed_survey
  end

  def down
    add_column :students, :completed_survey, :boolean, default: false
    add_column :schools, :completed_survey, :boolean, default: false
  end
end
