require "spec_helper"

describe "Router" do
  before do
    @school = Factory.create(:school, username: "Username")
    @student = Factory.create(:student, username: "Username")
  end

  def login_as(user)
    ApplicationController.any_instance.stub(:authenticate!)
    ApplicationController.any_instance.stub(:user_logged_in?) { true }
    ApplicationController.any_instance.stub(:current_user) { user }
    yield
    ApplicationController.any_instance.unstub(:authenticate!)
    ApplicationController.any_instance.unstub(:user_logged_in?)
    ApplicationController.any_instance.unstub(:current_user)
  end

  it "supports legacy routes" do
    request_via_redirect(:get, "login")
    request_via_redirect(:get, "schools/new")
    request_via_redirect(:get, "students/new")
    request_via_redirect(:get, "game/new")
    request_via_redirect(:get, "schools/:id")
    request_via_redirect(:get, "students/:id")
    login_as(@school) { request_via_redirect(:get, "students") }
    login_as(@school) { request_via_redirect(:get, "quizzes") }
  end
end
