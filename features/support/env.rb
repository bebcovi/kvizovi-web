require "cucumber/rails"
require "pry"

Before("@school")  { @user_type = "school" }
Before("@student") { @user_type = "student" }

World(Module.new do
  def school(&block)
    yield if @user_type == "school" or (@user && @user.type == "school")
  end

  def student(&block)
    yield if @user_type == "student" or (@user && @user.type == "student")
  end
end)
