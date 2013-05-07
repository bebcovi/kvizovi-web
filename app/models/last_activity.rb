class LastActivity
  def self.for(user)
    time = $redis.get(key(user))
    Time.parse(time) if time
  end

  def self.key(user)
    case user
    when School  then school_key(user)
    when Student then student_key(user)
    end
  end

  def self.school_key(school)
    "last_activity:school:#{school.username}"
  end

  def self.student_key(student)
    "last_activity:school:#{student.username}"
  end
end
