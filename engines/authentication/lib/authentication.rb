module Lektire
  module Authentication
    class Engine < Rails::Engine
      endpoint
    end
  end
end

require_relative "authentication/application_controller_methods"
