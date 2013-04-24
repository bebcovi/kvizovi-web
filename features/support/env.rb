require "cucumber/rails"
require "pry"

Before("@school")  { @user_type = "school" }
Before("@student") { @user_type = "student" }

World(Module.new do
  def school(&block)
    yield if @user_type == "school"
  end

  def student(&block)
    yield if @user_type == "student"
  end
end)
