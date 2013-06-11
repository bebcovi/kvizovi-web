RSpec.configure do |config|
  config.before(:each, type: :request) do
    host! "example.com"
    ApplicationController.any_instance.stub(:force_filling_email)
  end
end
