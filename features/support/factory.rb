require "factory_girl"

module FactoryGirl
  def self.definitions_loaded?
    factories.registered?(:school)
  end
end

FactoryGirl.find_definitions unless FactoryGirl.definitions_loaded?

Factory = FactoryGirl unless defined?(Factory)
