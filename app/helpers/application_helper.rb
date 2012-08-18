module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter"
    presenter = klass.new(object, self)
    yield presenter
  end

  def back_button(string, path, options = {})
    link_to "&larr; #{string}".html_safe, path, options
  end

  def logout_button(string, path, options = {})
    link_to string, path, {method: :delete}.merge(options)
  end

  def edit_button(string, path, options = {})
    link_to string.prepend_icon("pencil"), path, options
  end

  def delete_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {method: :delete, confirm: "Jeste li sigurni?"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string.prepend_icon("plus"), path, options
  end
end
