Before("@student") do
  @user_type = "student"
  host! "student.#{host}"
end

module StudentHelpers
  def student?
    @user_type == "student"
  end
end

World(StudentHelpers)
