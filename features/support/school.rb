Before("@school") do
  @user_type = "school"
end

module SchoolHelpers
  def school?
    @user_type == "school"
  end
end

World(SchoolHelpers)
