class ConfirmAllRegistrations < ActiveRecord::Migration
  class School < ActiveRecord::Base
  end

  class Student < ActiveRecord::Base
  end

  def change
    [School, Student].each do |user_class|
      user_class.update_all(confirmed_at: Time.now)
    end
  end
end
