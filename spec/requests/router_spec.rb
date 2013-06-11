require "spec_helper"

describe "Router" do
  def login_as(user)
    ApplicationController.any_instance.stub(:user_logged_in?) { true }
    ApplicationController.any_instance.stub(:current_user) { user }
    yield
    ApplicationController.any_instance.unstub(:user_logged_in?)
    ApplicationController.any_instance.unstub(:current_user)
  end

  it "supports legacy routes" do
    school = FactoryGirl.create(:school, username: "jon")
    student = FactoryGirl.create(:student, username: "jon")

    host! "example.com"
    request_via_redirect(:get, "login")
    expect(request.url).to eq root_url

    host! "example.com"
    request_via_redirect(:get, "schools/new")
    expect(request.url).to eq new_authorization_url

    host! "example.com"
    request_via_redirect(:get, "students/new")
    expect(request.url).to eq new_registration_url

    host! "example.com"
    login_as(student) { request_via_redirect(:get, "game/new") }
    expect(request.url).to eq choose_quiz_url

    host! "example.com"
    login_as(school) { request_via_redirect(:get, "schools/#{school.id}") }
    expect(request.url).to eq profile_url

    host! "example.com"
    login_as(student) { request_via_redirect(:get, "students/#{student.id}") }
    expect(request.url).to eq profile_url

    host! "example.com"
    login_as(school) { request_via_redirect(:get, "students") }
    expect(request.url).to eq students_url

    host! "example.com"
    login_as(school) { request_via_redirect(:get, "quizzes") }
    expect(request.url).to eq quizzes_url
  end

  it "redirects the heroku domain to the custom domain" do
    host! "lektire.herokuapp.com"
    request_via_redirect(:get, "")
    expect(request.host).to eq "kvizovi.org"
  end

  it "redirects www domains to normal domains" do
    host! "www.example.com"
    request_via_redirect(:get, "")
    expect(request.host).to eq "example.com"
  end
end
