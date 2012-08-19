class User
  def self.authenticate(credentials)
    school = School.authenticate(credentials)
    unless school.nil?
      school
    else
      Student.authenticate(credentials)
    end
  end
end
