# encoding: utf-8

module ApplicationHelper
  def body_class
    [params[:controller], params[:action]].join(" ")
  end

  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter
  end

  def breadcrumb(items)
    content_tag :ol, class: "breadcrumb" do
      items.map.with_index do |(name, path), index|
        if index < items.count - 1
          content_tag :li do
            link_to(name, path) +
            content_tag(:i, class: "divider") { icon("chevron-right") }
          end
        else
          content_tag :li, class: "active" do
            name
          end
        end
      end.join.html_safe
    end
  end

  def contact_link(string, options = {})
    mail_to "matija.marohnic@gmail.com, janko.marohnic@gmail.com", string, {target: "_blank"}.merge(options)
  end

  def back_button(string, path, options = {})
    link_to string.prepend_icon("arrow-left"), path, {class: "go_back"}.merge(options)
  end

  def logout_button(string, path, options = {})
    link_to string.prepend_icon("exit"), path, options
  end

  def change_password_button(string, path, options = {})
    link_to string.prepend_icon("locked"), path, {class: "btn"}.merge(options)
  end

  def delete_profile_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {class: "delete_profile"}.merge(options)
  end

  def edit_button(string, path, options = {})
    link_to string.prepend_icon("pencil"), path, {class: "edit_item btn"}.merge(options)
  end

  def delete_button(string, path, options = {})
    link_to string.prepend_icon("remove"), path, {class: "delete_item btn btn-danger"}.merge(options)
  end

  def add_button(string, path, options = {})
    link_to string.prepend_icon("plus"), path, {class: "add_item btn btn-primary"}.merge(options)
  end

  def remove_button(options = {})
    content_tag :button, "×", type: "button", class: "close", data: {dismiss: options[:dismiss]}
  end

  def settings_button(string, path, options = {})
    link_to string.prepend_icon("cog"), path, options
  end

  def alert_message(string, type, options = {})
    options[:close] = true if options[:close].nil?
    content_tag :div, raw("#{remove_button(dismiss: "alert")}#{string}"), class: "alert alert-#{type} fade in #{"no-close" unless options[:close]}"
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
    content_tag :div, class: "btn-toolbar" do
      yield ButtonBuilder.new(form_builder, self)
    end
  end

  class ButtonBuilder
    def initialize(form_builder, template)
      @form_builder = form_builder
      @template = template
    end

    def cancel_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "btn cancel")
      args << options
      @template.link_to *args
    end

    def action_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "action btn btn-primary")
      args << options

      @template.link_to *args
    end

    def submit_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "btn btn-primary", data: {"disable-with" => "Učitavanje..."})
      args << options

      if @form_builder
        @form_builder.button :submit, *args
      else
        @template.button_tag *args
      end
    end

    def button_button(*args)
      options = args.extract_options!.dup
      options.reverse_merge!(class: "btn-primary", data: {"disable-with" => "Učitavanje..."})
      args << options
      @form_builder.button :button, *args
    end
  end

  Page = Class.new(Struct.new(:title, :path, :active)) { alias active? active }
  def navigation_pages_for(user)
    result = []

    if user.is_a?(School)
      result << Page.new("Kvizovi", quizzes_path, (params[:controller] == "quizzes" or (params[:controller] == "questions" and @scope.is_a?(Quiz)) or (params[:controller] == "questions" and params[:include].present?)))
      result << Page.new("Pitanja", school_questions_path(user), (params[:controller] == "questions" and not @scope.is_a?(Quiz) and not params[:include].present?))
      result << Page.new("Učenici", students_path, params[:controller] == "students")
    elsif user.is_a?(Student)
      result << Page.new("Kvizovi", new_game_path, params[:controller] == "games")
    end

    result << Page.new("Vodič", tour_path, params[:controller] == "tour")

    result
  end
end
