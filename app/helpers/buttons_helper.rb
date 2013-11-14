module ButtonsHelper
  def primary_button(text, path, options = {})
    button text, path, options.merge_class("btn-primary")
  end

  def submit_button(text, options = {})
    button_tag text, options.merge_class("btn btn-primary")
  end

  def back_button(text, path, options = {})
    primary_button text.prepend_icon("arrow-left"), path, options
  end

  def cancel_button(text, path, options = {})
    button text, path, options.deep_merge(data: {dismiss: "modal"})
  end

  def delete_button(text, path, options = {})
    button text.prepend_icon("remove"), path, options.merge_class("btn-danger").deep_merge(method: :delete)
  end

  def edit_button(text, path, options = {})
    button text.prepend_icon("pencil-2"), path, options
  end

  def add_button(text, path, options = {})
    primary_button text.prepend_icon("plus"), path, options.merge_class("add")
  end

  def dismiss_button(object, options = {})
    content_tag :button, "×", options.deep_merge(type: "button", data: {dismiss: object})
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
