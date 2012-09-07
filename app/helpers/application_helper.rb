# encoding: utf-8

module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter
  end

  def back_button(string, path, options = {})
    link_to string.prepend_icon("arrow-left"), path, options
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

  def preview_button(string, path, options = {})
    link_to string.prepend_icon("search"), path, options
  end

  def delete_button(string, path, options = {})
    link_to string.prepend_icon("trash"), path, {method: :delete, confirm: "Jeste li sigurni?"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string.prepend_icon("plus"), path, options
  end

  def close_button(options = {})
    content_tag :button, "".prepend_icon("remove"), options
  end

  def settings_button(string, path, options = {})
    link_to string.prepend_icon("cog"), path, options
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

  def input_collection(form_builder)
    f = form_builder.dup.tap do |f|
      def f.input(attribute_name, options = {})
        @n = @n.to_i + 1
        name = "#{object_name}[#{attribute_name}][]"
        id = name.gsub(/\[([^\]]+)\]/, '_\1').sub(/\[\]$/, "_#{@n}")
        label_text = "#{Nokogiri::HTML(label(attribute_name)).at(:label).inner_text} #{@n}"
        super(attribute_name, {input_html: {id: id, name: name}, label: label_text, label_html: {for: id}}.deep_merge(options))
      end
    end
    yield f
  end

  def smarty_pants(text)
    Redcarpet::Render::SmartyPants.render(text.to_s).html_safe
  end
end
