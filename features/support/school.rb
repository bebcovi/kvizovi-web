Before("@school") do
  @user_type = "school"
  host! "school.#{host.match(/^(www\.)?/).post_match}"
end

module SchoolHelpers
  def school?
    @user_type == "school"
  end
end

World(SchoolHelpers)
