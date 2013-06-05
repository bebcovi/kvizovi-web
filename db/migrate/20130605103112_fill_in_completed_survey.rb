class FillInCompletedSurvey < ActiveRecord::Migration
  class School < ActiveRecord::Base
  end

  class Student < ActiveRecord::Base
  end

  class Survey < ActiveRecord::Base
    belongs_to :user, polymorphic: true
  end

  def up
    Survey.find_each do |survey|
      survey.user.update_column(:completed_survey, true)
    end
  end

  def down
  end
end
