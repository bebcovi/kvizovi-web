require "capybara"

Capybara.add_selector :record do
  xpath { |record| XPath.css("#" + ActionView::RecordIdentifier.dom_id(record)) }
  match { |record| record.is_a?(ActiveRecord::Base) }
end
