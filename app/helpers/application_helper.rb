require_relative "../../lib/markdown_rendering"

module ApplicationHelper
  include MarkdownRendering

  def title(text)
    @title = text
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
        super(attribute_name, {input_html: {id: id, name: name}, label_html: {for: id}}.deep_merge(options))
      end
    end
    yield f
  end

  def percentage(part, total)
    (part/total.to_f * 100).round
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

    result << Page.new("Vodič", tour_path, params[:action] == "tour")

    result
  end

  def regions
    REGIONS
  end

  REGIONS = [
    "Bjelovarsko-bilogorska županija",
    "Brodsko-posavska županija",
    "Dubrovačko-neretvanska županija",
    "Grad Zagreb",
    "Istarska županija",
    "Karlovačka županija",
    "Koprivničko-križevačka županija",
    "Krapinsko-zagorska županija",
    "Ličko-@senjska županija",
    "Međimurska županija",
    "Osječko-baranjska županija",
    "Požeško-slavonska županija",
    "Primorsko-goranska županija",
    "Sisačko-moslavačka županija",
    "Splitsko-dalmatinska županija",
    "Šibensko-kninska županija",
    "Varaždinska županija",
    "Virovitičko-podravska županija",
    "Vukovarsko-srijemska županija",
    "Zagrebačka županija",
    "Zadarska županija",
  ]
end
