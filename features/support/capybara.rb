require "capybara"
require "capybara/cucumber"
require "capybara/poltergeist"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.javascript_driver = :poltergeist

Before("@javascript") do |scenario|
  host! "#{@user_type}.lvh.me:#{Capybara.current_session.server.port}"
end

Capybara.add_selector :record do
  xpath { |record| XPath.css("#" + ActionController::RecordIdentifier.dom_id(record)) }
  match { |record| record.is_a?(ActiveRecord::Base) }
end

module CapybaraHelpers
  def refresh
    visit current_url
  end

  def ensure_on(url)
    visit url unless current_url == url
  end
end

World(CapybaraHelpers)
