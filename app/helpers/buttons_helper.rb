module ButtonsHelper
  def primary_button(string, path, options = {})
    button string, path, options.merge_class("btn-primary")
  end

  def submit_button(string, options = {})
    button_tag string, options.merge_class("btn btn-primary").deep_merge(data: {:"disable-with" => "Učitavanje..."})
  end

  def back_button(string, path, options = {})
    primary_button string.prepend_icon("arrow-left"), path, options
  end

  def cancel_button(string, path, options = {})
    button string, path, options.deep_merge(data: {dismiss: "modal"})
  end

  def delete_button(string, path, options = {})
    button string.prepend_icon("remove"), path, options.merge_class("btn-danger").deep_merge(method: :delete)
  end

  def edit_button(string, path, options = {})
    button string.prepend_icon("pencil-2"), path, options
  end

  def add_button(string, path, options = {})
    primary_button string.prepend_icon("plus"), path, options
  end

  def remove_button(options = {})
    options[:data] = {dismiss: options.delete(:dismiss)} if options[:dismiss]
    content_tag :button, icon("close"), options.merge_class("close").deep_merge(type: "button")
  end

  def next_button(string, path, options = {})
    primary_button string.append_icon("arrow-right"), path, options
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
