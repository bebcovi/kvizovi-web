module ControllerHelpers
  extend ActiveSupport::Concern

  def login_as(user)
    controller.send(:log_in!, user)
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
  config.before(:each, type: :controller) do
    request.host = "#{example.metadata[:user]}.#{request.host}"
  end
  config.before(:each, type: :controller) do
    controller.stub(:force_filling_email)
  end
  config.before(:each, type: :request) do
    ApplicationController.any_instance.stub(:force_filling_email)
  end
end
