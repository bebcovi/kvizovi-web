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
      items.inject(raw("")) do |crumbs, item|
        crumbs << content_tag(:li, class: ("active" if item == items.last)) { raw(item) } + "\n"
      end
    end
  end

  def alert_message(string, type, options = {})
    options.reverse_merge!(close: true)
    options.merge_class!("alert alert-#{type} fade in")
    options.merge_class!("no-close") unless options[:close]

    content_tag :div, dismiss_button("alert", class: "close") + string, options
  end

  def icon(name, options = {})
    content_tag :i, "", options.merge_class("icon-#{name}")
  end

  def number(n)
    {1 => "one", 2 => "two"}[n]
  end

  def percentage(part, total)
    unless total.zero?
      ((part.to_f / total.to_f) * 100).round
    else
      0
    end
  end

  def active_content_tag(tag_name, active, options = {}, &block)
    css_class = "active" if active
    content_tag tag_name, options.merge_class(css_class), &block
  end
end
