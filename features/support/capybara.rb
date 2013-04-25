require "capybara"

Capybara.add_selector :record do
  xpath { |record| XPath.css("#" + ActionController::RecordIdentifier.dom_id(record)) }
  match { |record| record.is_a?(ActiveRecord::Base) }
end

module CapybaraHelpers
  def refresh
    visit current_url
  end
end

World(CapybaraHelpers)
