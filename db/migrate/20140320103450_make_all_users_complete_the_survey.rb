class MakeAllUsersCompleteTheSurvey < ActiveRecord::Migration
  Student = Class.new(ActiveRecord::Base)
  School  = Class.new(ActiveRecord::Base)

  def up
    [Student, School].each do |user_class|
      user_class.update_all(completed_survey: true)
    end
  end
end
