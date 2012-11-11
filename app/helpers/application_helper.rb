# encoding: utf-8

module ApplicationHelper
  def body_class
    [params[:controller], params[:action]].join(" ")
  end

  def log_message
    if user_logged_in?
      if current_user.is_a?(Student)
        student = current_user
        raw "Bok, #{link_to student.first_name, student} | #{logout_button "Odjava", logout_path}"
      else
        school = current_user
        raw "Prijavljeni ste kao #{link_to school.name, school} | #{logout_button "Odjava", logout_path}"
      end
    end
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter
  end

  def contact_link(string, options = {})
    mail_to "matija.marohnic@gmail.com, janko.marohnic@gmail.com", string, {target: "_blank"}.merge(options)
  end

  def back_button(string, path, options = {})
    link_to string.prepend_icon("arrow-left"), path, {class: "go_back"}.merge(options)
  end

  def logout_button(string, path, options = {})
    link_to string.prepend_icon("exit"), path, {method: :delete}.merge(options)
  end

  def change_password_button(string, path, options = {})
    link_to string.prepend_icon("locked"), path, options
  end

  def edit_button(string, path, options = {})
    link_to string.prepend_icon("pencil"), path, options
  end

  def preview_button(string, path, options = {})
    link_to string.prepend_icon("search"), path, options
  end

  def delete_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {class: "delete"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string.prepend_icon("plus"), path, options
  end

  def remove_button(options = {})
    content_tag :button, "".prepend_icon("cancel"), {class: "remove"}.merge(options)
  end

  def settings_button(string, path, options = {})
    link_to string.prepend_icon("cog"), path, options
  end

  def notice(string, options = {})
    content_tag :p, string.prepend_icon("info"), {class: "notice"}.merge(options)
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

  def markdown(text)
    smarty_pants(Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text))
  end

  def percentage(part, total)
    (part/total.to_f * 100).round
  end

  def buttons(form_builder = nil)
    content_tag :div, class: "form_controls" do
      yield ButtonBuilder.new(form_builder, self)
    end
  end

  class ButtonBuilder
    def initialize(form_builder, template)
      @form_builder = form_builder
      @template = template
    end

    def cancel_button(*args)
      @template.link_to *args
    end

    def action_button(*args)
      options = args.extract_options!.dup
      options.update(class: "action")
      args << options

      @template.link_to *args
    end

    def submit_button(*args)
      options = args.extract_options!.dup
      options.deep_merge!(data: {"disable-with" => "Učitavanje..."})
      args << options

      if @form_builder
        @form_builder.button :submit, *args
      else
        @template.button_tag *args
      end
    end

    def button_button(*args)
      options = args.extract_options!.dup
      options.deep_merge!(data: {"disable-with" => "Učitavanje..."})
      args << options
      @form_builder.button :button, *args
    end
  end

  def tag_filter
    simple_form_for :filter, url: request.path, method: "get" do |f|
      f.input(:tags, input_html: {name: "tags", value: params[:tags]}) +
      buttons(f) do |b|
        b.button_button("Filtrirajte", name: nil) +
        b.cancel_button("Očistite filter", request.path)
      end
    end
  end
end
