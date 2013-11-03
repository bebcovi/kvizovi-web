RSpec.configure do |config|
  config.before(:each, type: :controller) do
    controller.stub(:force_filling_email)
  end
  config.include Devise::TestHelpers, type: :controller
end
