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

  def breadcrumbs(*items)
    content_tag :ol, class: "breadcrumb" do
      items.map.with_index do |item, idx|
        if idx < items.count - 1
          content_tag(:li) do
            raw(item) + content_tag(:i, class: "divider") { icon("chevron-right") }
          end
        else
          content_tag(:li, class: "active") do
            raw(item)
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

  def remote_form_for(*args, &block)
    simple_form_for *args do |f|
      concat hidden_field_tag(:return_to, request.fullpath)
      yield(f)
    end
  end

  def active_content_tag(tag_name, active, options = {}, &block)
    content_tag tag_name, {class: ("active" if active)}.merge(options), &block
  end

  def current_user_admin?
    user_logged_in? && current_user.admin?
  end
end
