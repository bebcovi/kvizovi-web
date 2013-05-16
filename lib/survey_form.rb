require "ostruct"

module SurveyForm
  class FormBuilder
    def initialize(form_builder, template, defaults = {})
      @form_builder, @template = form_builder, template
      @defaults = defaults
    end

    def choice_question(text, options = {})
      Questions::Choice.new(@form_builder, @template).render(text, @defaults.merge(options))
    end

    def text_question(text, options = {})
      Questions::Text.new(@form_builder, @template).render(text, @defaults.merge(options))
    end

    def range_question(text, options = {})
      Questions::Range.new(@form_builder, @template).render(text, @defaults.merge(options))
    end
  end

  module Questions
    class Abstract
      def initialize(form_builder, template)
        @f, @t = form_builder, template
      end

      def render(text, options, &block)
        @f.simple_fields_for :fields, field(text) do |f|
          result = f.hidden_field :question
          result += f.hidden_field :choices, value: options[:choices].join("@") if options[:choices]
          result += f.hidden_field :required, value: true if options[:required]
          result += f.hidden_field :category, value: self.class.name.demodulize.underscore
          result += yield(f)
          result
        end
      end

      private

      def field(question)
        if survey.fields.any?
          survey.fields.find { |field| field.question == question }
        else
          SurveyField.new(question: question)
        end
      end

      def survey
        @f.object
      end

      def required_asterisk
        @t.content_tag :span, "*", class: "required"
      end

      def label(text, options = {})
        result = text
        result += " #{required_asterisk}" if options[:required]
        result.html_safe
      end
    end

    class Choice < Abstract
      def render(text, options = {})
        super do |f|
          f.input(:answer,
            label: label(text, options),
            as: options[:multiple] ? :check_boxes : :radio_buttons,
            collection: options[:choices],
            hint: options[:hint])
        end
      end
    end

    class Text < Abstract
      def render(text, options = {})
        super do |f|
          f.input(:answer,
            label: label(text, options),
            as: options[:input] == :text_area ? :text : :string,
            input_html: options[:input] == :text_area ? {rows: 3} : {},
            hint: options[:hint])
        end
      end
    end

    class Range < Abstract
      def render(text, options = {})
        super do |f|
          f.input :answer, label: label(text, options) do
            @t.content_tag(:table, class: "table table-striped") do
              @t.content_tag(:thead) do
                @t.content_tag(:tr) do
                  @t.content_tag(:td) +
                  options[:choices].
                    map { |name| @t.content_tag(:td, name) }.
                    inject(:+)
                end
              end +
              @t.content_tag(:tbody) do
                options[:aspects].
                  map.with_index do |name, idx|
                    aspect = f.object.answer.present? ? f.object.answer[idx] : {name: name}
                    f.simple_fields_for :answer, OpenStruct.new(aspect), index: idx do |a|
                      @t.content_tag(:tr) do
                        a.hidden_field(:name) +
                        @t.content_tag(:td, name) +
                        options[:choices].
                          map do |name|
                            @t.content_tag(:td) do
                              a.radio_button(:answer, name)
                            end
                          end.
                          inject(:+)
                      end
                    end
                  end.
                  inject(:+)
              end
            end
          end
        end
      end
    end
  end
end

module ActionView
  class Base
    def survey_form(survey, options = {}, &block)
      simple_form_for survey do |f|
        yield SurveyForm::FormBuilder.new(f, self, options[:defaults] || {})
      end
    end
  end
end
