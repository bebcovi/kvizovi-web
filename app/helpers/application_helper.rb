module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter"
    presenter = klass.new(object, self)
    yield presenter
  end

  def edit_button(string, path, options = {})
    link_to string, path, options
  end

  def delete_button(string, path, options = {})
    link_to string, path, {method: :delete, confirm: "Jeste li sigurni?"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string, path, options
  end
end
