require "factory_girl"

$load_factories = true
FactoryGirl.factories.clear
Dir[Rails.root.join("features/support/factories/**/*.rb")].each &method(:require)
$load_factories = false

Factory = FactoryGirl unless defined?(Factory)
