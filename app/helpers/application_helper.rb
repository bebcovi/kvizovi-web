# encoding: utf-8

module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter
  end

  def back_button(string, path, options = {})
    link_to string.prepend_icon("hand-left"), path, options
  end

  def logout_button(string, path, options = {})
    link_to string, path, {method: :delete}.merge(options)
  end

  def change_password_button(string, path, options = {})
    link_to string.prepend_icon("lock"), path, options
  end

  def edit_button(string, path, options = {})
    link_to string.prepend_icon("edit"), path, options
  end

  def delete_button(string, path, options = {})
    link_to string.prepend_icon("trash"), path, {method: :delete, confirm: "Jesi li siguran?"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string.prepend_icon("plus"), path, options
  end

  def icon(name, options = {})
    klass = "icon-#{name}"
    klass += " #{options[:class]}" if options[:class]
    content_tag :i, "", {class: klass}.merge(options.except(:class))
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

  def number(n)
    case n
    when 1 then "one"
    when 2 then "two"
    end
  end
end
