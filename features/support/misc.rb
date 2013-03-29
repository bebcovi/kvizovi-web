module MiscHelpers
  def school(&block)
    yield if @user_type == "school"
  end

  def student(&block)
    yield if @user_type == "student"
  end
end

World(MiscHelpers)
