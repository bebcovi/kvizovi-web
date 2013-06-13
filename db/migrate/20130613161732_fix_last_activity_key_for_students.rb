class FixLastActivityKeyForStudents < ActiveRecord::Migration
  class Student < ActiveRecord::Base
  end

  def up
    Student.find_each do |student|
      $redis.set("last_activity:student:#{student.username}", $redis.get("last_activity:school:#{student.username}"))
    end if defined?($redis)
  end

  def down
  end
end
