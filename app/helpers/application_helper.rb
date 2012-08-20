# encoding: utf-8

module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
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

  def icon(name)
    content_tag :i, "", class: "icon-#{name}"
  end

  def ordinalize(argument)
    if argument.is_a?(Integer)
      ORDINALS[argument]
    elsif argument.is_a?(Enumerable)
      argument.map { |number| ORDINALS[number] }
    end
  end

  ORDINALS = {
    1 => "Prvi",
    2 => "Drugi",
    3 => "Treći",
    4 => "Četvrti",
    5 => "Peti",
    6 => "Šesti",
    7 => "Sedmi",
    8 => "Osmi"
  }
end
