require_relative "../../lib/markdown_rendering"

module ApplicationHelper
  include MarkdownRendering

  def title(text)
    @title = text
  end

  def navigation_pages_for(user)
    send("#{user.type}_navigation_pages")
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter
  end

  def breadcrumb(items)
    content_tag :ol, class: "breadcrumb" do
      items.map.with_index do |(name, path), index|
        if index < items.count - 1
          content_tag :li do
            link_to(name, path) +
            content_tag(:i, class: "divider") { icon("chevron-right") }
          end
        else
          content_tag :li, class: "active" do
            name
          end
        end
      end.join.html_safe
    end
  end

  def contact_link(string, options = {})
    mail_to "matija.marohnic@gmail.com, janko.marohnic@gmail.com", string, {target: "_blank"}.merge(options)
  end

  def alert_message(string, type, options = {})
    options[:close] = true if options[:close].nil?
    content_tag :div, raw("#{remove_button(dismiss: "alert")}#{string}"), class: "alert alert-#{type} fade in #{"no-close" unless options[:close]}"
  end

  def icon(name, options = {})
    klass = "icon-#{name}"
    klass += " #{options[:class]}" if options[:class]
    content_tag :i, "", {class: klass}.merge(options.except(:class))
  end

  def number(n)
    {1 => "one", 2 => "two"}[n]
  end

  def input_collection(form_builder)
    f = form_builder.dup.tap do |f|
      def f.input(attribute_name, options = {})
        @n = @n.to_i + 1
        name = "#{object_name}[#{attribute_name}][]"
        id = name.gsub(/\[([^\]]+)\]/, '_\1').sub(/\[\]$/, "_#{@n}")
        super(attribute_name, {input_html: {id: id, name: name}, label_html: {for: id}}.deep_merge(options))
      end
    end
    yield f
  end

  def percentage(part, total)
    (part/total.to_f * 100).round
  end
end
