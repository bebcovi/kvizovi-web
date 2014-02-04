require "capybara"
require "capybara/poltergeist"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

Capybara.javascript_driver = :poltergeist

Capybara.add_selector :record do
  xpath { |record| XPath.css("#" + ActionView::RecordIdentifier.dom_id(record)) }
  match { |record| record.is_a?(ActiveRecord::Base) }
end

module XPath
  module HTML
    # When applying tooltips to elements, Twitter Bootstrap replaces the "title"
    # attribute with "data-original-title". This override enables methods like
    # `#click_on` to also search by "data-original-title".
    def link(locator)
      locator = locator.to_s
      link = descendant(:a)[attr(:href)]
      link[attr(:id).equals(locator) | string.n.is(locator) | attr(:title).is(locator) | attr(:"data-original-title").is(locator) | descendant(:img)[attr(:alt).is(locator)]]
    end
  end
end
