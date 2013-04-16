module ControllerHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    def school!
      before { request.host = "school.example.com" }
    end

    def student!
      before { request.host = "student.example.com" }
    end
  end
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end
