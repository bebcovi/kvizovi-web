module ButtonsHelper
  def default_button(text, path, options = {})
    button text, path, options.merge_class("btn-default")
  end

  def primary_button(text, path, options = {})
    button text, path, options.merge_class("btn-primary")
  end

  def submit_button(text, options = {})
    button_tag text, {data: {:"disable-with" => "Učitavanje..."}}.deep_merge(options.merge_class("btn btn-primary"))
  end

  def back_button(text, path, options = {})
    primary_button text.prepend_icon("arrow-left"), path, options
  end

  def cancel_button(text, path, options = {})
    default_button text, path, {data: {dismiss: "modal"}, class: "btn-default"}.deep_merge(options)
  end

  def delete_button(text, path, options = {})
    button text.prepend_icon("remove"), path, {method: :delete}.deep_merge(options.merge_class("btn-danger"))
  end

  def edit_button(text, path, options = {})
    default_button text.prepend_icon("pencil2"), path, options
  end

  def add_button(text, path, options = {})
    primary_button text.prepend_icon("plus"), path, options.merge_class("add")
  end

  def dismiss_button(object, options = {})
    content_tag :button, "×", {type: "button", data: {dismiss: object}}.deep_merge(options)
  end

  def next_button(text, path, options = {})
    primary_button text.append_icon("arrow-right"), path, options
  end

  def button(*args)
    options = args.extract_options!
    options.merge_class!("btn")
    args << options

    link_to *args
  end

  def buttons(options = {}, &block)
    content_tag :div, options.merge_class("btn-toolbar"), &block
  end
end
