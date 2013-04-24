module ControllerHelpers
  extend ActiveSupport::Concern

  def login_as(user)
    controller.stub(:authenticate!)
    controller.stub(:user_logged_in?) { true }
    controller.stub(:current_user) { user }
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
  config.before(:each, type: :controller) do
    request.host = [example.metadata[:user], "example.com"].compact.join(".")
  end
end
