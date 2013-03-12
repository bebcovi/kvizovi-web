class RegistrationCallbacks
  def initialize(user)
    @user = user
  end

  def save
    @user.save
    execute_callbacks
  end

  private

  def execute_callbacks
    send("execute_#{@user.class.name.underscore}_callbacks")
  end

  def execute_student_callbacks
  end

  def execute_school_callbacks
    ExampleQuizzesCreator.new(@user).create
  end
end
