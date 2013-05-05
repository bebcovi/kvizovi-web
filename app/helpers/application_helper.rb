require_relative "../../lib/markdown_rendering"

module ApplicationHelper
  include MarkdownRendering

  def title(text = nil)
    if text
      @title = text
    else
      @title
    end
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter
  end

  def exhibit(record, exhibit_class = nil)
    exhibit_class ||= "#{record.class.name}Exhibit".constantize
    exhibit_class.new(record, self)
  end

  def breadcrumbs(*items, last_item)
    content_tag :ol, class: "breadcrumb" do
      items.map do |name, path|
        content_tag(:li) do
          link_to(name, path) +
          content_tag(:i, class: "divider") { icon("chevron-right") }
        end
      end.join.html_safe +
      content_tag(:li, class: "active") do
        last_item
      end
    end
  end

  def contact_link(string, options = {})
    mail_to "matija.marohnic@gmail.com, janko.marohnic@gmail.com", string, {target: "_blank"}.merge(options)
  end

  def alert_message(string, type, options = {})
    options[:close] = true if options[:close].nil?
    content_tag :div, raw("#{remove_button(dismiss: "alert")}#{string}"), class: "alert alert-#{type} fade in #{options[:class]} #{"no-close" unless options[:close]}"
  end

  def icon(name, options = {})
    klass = "icon-#{name}"
    klass += " #{options[:class]}" if options[:class]
    content_tag :i, "", {class: klass}.merge(options.except(:class))
  end

  def number(n)
    {1 => "one", 2 => "two"}[n]
  end

  def percentage(part, total)
    ((part.to_f / total.to_f) * 100).round
  end
end
